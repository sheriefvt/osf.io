Hello  ${user.fullname},

% if is_pre_moderation:
    Your submission "${reviewable_title}", submitted to ${provider.name} has ${'not been accepted. You may edit the preprint and resubmit, at which time it will becoming pending moderation.' if is_rejected else 'been accepted by the moderator and is now discoverable to others.'}
% else:
    Your submission "${reviewable_title}" , submitted to ${provider.name} has ${'has not been accepted and will be made private and not discoverable by others. You may edit the preprint and contact the moderator to resubmit.' if is_rejected else 'been accepted by the moderator and remains discoverable to others. '} ${'The moderator has also provided a comment that is only visible to contributors of the preprint, and not to others. ' if notify_comment else ''}
% endif

You will ${'not receive ' if all_global_subscriptions_none else 'be automatically subscribed to '} notification emails for this preprint. Each preprint is associated with a project on the Open Science Framework for managing the preprint.  To change your email notification preferences, visit your project user settings: ${settings + "settings/notifications/"}

If you have been  erroneously associated with "${reviewable_title}," then you may visit the project's "Contributors" page and remove yourself as a contributor.


Sincerely,

Your ${provider.name} and OSF teams


Want more information? Visit ${provider_url} to learn more about ${provider.name} or https://osf.io/ to learn about the Open Science Framework.

Questions? Email contact@osf.io
