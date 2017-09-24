Hello  ${user.fullname},

% if is_creator:
    Your preprint ${reviewable_title} has been successfully submitted to ${provider.name}.
% else:
    ${referrer.fullname} has added you as a contributor to the preprint ${reviewable_title} on ${provider.name}, which is hosted on the Open Science Framework: ${reviewable_url}.
% endif

% if is_pre_moderation:
    ${provider.name} has chosen to moderate their submissions using a pre-moderation workflow, which means your submission is pending until accepted by a moderator. You will receive a separate notification informing you of any status changes.
% else:
    ${provider.name} has chosen to moderate their submissions using a post-moderation workflow, which means your submission is public and discoverable, while still pending acceptance by a moderator. You will receive a separate notification informing you of any status changes.
% endif

You will ${'not receive ' if no_future_emails else 'be automatically subscribed to '} future notification emails for this preprint. Each preprint is associated with a project on the Open Science Framework for managing the preprint.  To change your email notification preferences, visit your project user settings: ${settings + "settings/notifications/"}

If you have been  erroneously associated with "${reviewable_title}," then you may visit the project's "Contributors" page and remove yourself as a contributor.

For more information about ${provider.name}, visit ${provider_url} to learn more.  To learn about the Open Science Framework, visit https://osf.io/

For questions regarding submission criteria, please email ${provider_contact_email}


Sincerely,

Your ${provider.name} and OSF teams

Center for Open Science
210 Ridge McIntire Road, Suite 500, Charlottesville, VA 22903-5083

Privacy Policy: https://github.com/CenterForOpenScience/cos.io/blob/master/PRIVACY_POLICY.md
