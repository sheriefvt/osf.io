Hello ${user.fullname},

% if is_pre_moderation:
    Your submission "${reviewable_title}", submitted to ${provider.name} has ${'not been accepted. You may edit the '+ provider_preprint_word+ ' and resubmit, at which time it will becoming pending moderation.' if is_rejected else 'been accepted by the moderator and is now discoverable to others.'}
% else:
    Your submission "${reviewable_title}", submitted to ${provider.name} has ${'not been accepted and will be made private and not discoverable by others. You may edit the '+ provider_preprint_word+ ' and contact the moderator at '+ provider_support_email +' to resubmit.' if is_rejected else 'been accepted by the moderator and remains discoverable to others. '} ${'The moderator has also provided a comment that is only visible to contributors of the '+ provider_preprint_word+ ', and not to others. ' if notify_comment else ''}
% endif

You will ${'not receive ' if no_future_emails else 'be automatically subscribed to'} future notification emails for this ${provider_preprint_word}. Each ${provider_preprint_word} is associated with a project on the Open Science Framework for managing the ${provider_preprint_word}. To change your email notification preferences, visit your project user settings: ${settings + "settings/notifications/"}

If you have been erroneously associated with "${reviewable_title}," then you may visit the project's "Contributors" page and remove yourself as a contributor.

For more information about ${provider.name}, visit ${provider_url} to learn more. To learn about the Open Science Framework, visit https://osf.io/

For questions regarding submission criteria, please email ${provider_contact_email}


Sincerely,

Your ${provider.name} and OSF teams

Center for Open Science
210 Ridge McIntire Road, Suite 500, Charlottesville, VA 22903-5083

Privacy Policy: https://github.com/CenterForOpenScience/cos.io/blob/master/PRIVACY_POLICY.md
