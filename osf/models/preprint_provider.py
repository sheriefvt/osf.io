# -*- coding: utf-8 -*-
from django.db import models
from django.contrib.postgres import fields

from modularodm import Q

from osf.models.base import BaseModel, ObjectIDMixin
from osf.models.licenses import NodeLicense
from osf.models.subject import Subject
from osf.utils.datetime_aware_jsonfield import DateTimeAwareJSONField
from osf.utils.fields import EncryptedTextField

from reviews.models.mixins import ReviewProviderMixin

from website.util import api_v2_url


class PreprintProvider(ObjectIDMixin, ReviewProviderMixin, BaseModel):
    name = models.CharField(null=False, max_length=128)  # max length on prod: 22
    description = models.TextField(default='', blank=True)
    domain = models.URLField(blank=True, default='', max_length=200)
    domain_redirect_enabled = models.BooleanField(default=False)
    external_url = models.URLField(null=True, blank=True, max_length=200)  # max length on prod: 25
    email_contact = models.CharField(null=True, blank=True, max_length=200)  # max length on prod: 23
    email_support = models.CharField(null=True, blank=True, max_length=200)  # max length on prod: 23
    example = models.CharField(null=True, blank=True, max_length=20)  # max length on prod: 5
    access_token = EncryptedTextField(null=True, blank=True)
    advisory_board = models.TextField(default='', blank=True)
    social_twitter = models.CharField(null=True, blank=True, max_length=200)  # max length on prod: 8
    social_facebook = models.CharField(null=True, blank=True, max_length=200)  # max length on prod: 8
    social_instagram = models.CharField(null=True, blank=True, max_length=200)  # max length on prod: 8
    footer_links = models.TextField(default='', blank=True)
    share_source = models.CharField(blank=True, max_length=200)
    allow_submissions = models.BooleanField(default=True)
    additional_providers = fields.ArrayField(models.CharField(max_length=200), default=list, blank=True)

    subjects_acceptable = DateTimeAwareJSONField(blank=True, default=list)
    licenses_acceptable = models.ManyToManyField(NodeLicense, blank=True, related_name='licenses_acceptable')
    default_license = models.ForeignKey(NodeLicense, blank=True, related_name='default_license', null=True)

    class Meta:
        # custom permissions for use in the OSF Admin App
        permissions = (
            ('view_preprintprovider', 'Can view preprint provider details'),
        )

    def __unicode__(self):
        return '{} with id {}'.format(self.name, self.id)

    @property
    def highlighted_subjects(self):
        if self.subjects.filter(highlighted=True).exists():
            return self.subjects.filter(highlighted=True).order_by('text')[:10]
        else:
            return sorted(self.top_level_subjects, key=lambda s: s.text)[:10]

    @property
    def top_level_subjects(self):
        if self.subjects.exists():
            return self.subjects.filter(parent__isnull=True)
        else:
            # TODO: Delet this when all PreprintProviders have a mapping
            if len(self.subjects_acceptable) == 0:
                return Subject.objects.filter(parent__isnull=True, provider___id='osf')
            tops = set([sub[0][0] for sub in self.subjects_acceptable])
            return [Subject.load(sub) for sub in tops]

    @property
    def all_subjects(self):
        if self.subjects.exists():
            return self.subjects.all()
        else:
            # TODO: Delet this when all PreprintProviders have a mapping
            return rules_to_subjects(self.subjects_acceptable)

    def get_absolute_url(self):
        return '{}preprint_providers/{}'.format(self.absolute_api_v2_url, self._id)

    @property
    def absolute_api_v2_url(self):
        path = '/preprint_providers/{}/'.format(self._id)
        return api_v2_url(path)


def rules_to_subjects(rules):
    if not rules:
        return Subject.objects.filter(provider___id='osf')
    q = []
    for rule in rules:
        if rule[1]:
            q.append(Q('parent', 'eq', Subject.load(rule[0][-1])))
            if len(rule[0]) == 1:
                potential_parents = Subject.find(Q('parent', 'eq', Subject.load(rule[0][-1])))
                for parent in potential_parents:
                    q.append(Q('parent', 'eq', parent))
        for sub in rule[0]:
            q.append(Q('_id', 'eq', sub))
    return Subject.find(reduce(lambda x, y: x | y, q)) if len(q) > 1 else (Subject.find(q[0]) if len(q) else Subject.find())
