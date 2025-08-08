module Railsui
  class Default
    THEMES = {
      hound: {
        name: 'Hound',
        preview_link: 'https://hound.railsui.com/',
        thumbnail: 'tailwind-hound-thumbnail.jpg',
        category: 'CRM/Project Management'
      },
      shepherd: {
        name: 'Shepherd',
        preview_link: 'https://shepherd.railsui.com/',
        thumbnail: 'tailwind-shepherd-thumbnail.jpg',
        category: 'Property Management SaaS'
      },
      corgie: {
        name: 'Corgie',
        preview_link: 'https://corgie.railsui.com/',
        thumbnail: 'tailwind-corgie-thumbnail.jpg',
        category: 'Artificial Intelligence'
      }
    }

    THEME_PAGES = {
      default: %w[about activity assignments billing
                  calendar dashboard integrations message
                  messages notifications people pricing
                  profile project projects settings team],
      hound: %w[about activity assignments billing
                calendar dashboard integrations message
                messages notifications people pricing
                profile project projects settings team],
      shepherd: %w[about account_notifications account_payment_methods account_payouts account_preferences api booking
                   bookings calendar changelog contact dashboard edit_booking help_center inbox insights new_booking pricing privacy_policy properties terms],
      corgie: %w[home pricing features blog blog_show blog_new blog_category about terms privacy_policy signup login help chat_new chat_show]
    }

    BODY_CLASSES = {
      default: 'antialiased h-full bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-slate-800',
      hound: 'antialiased h-full bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-slate-800',
      shepherd: 'h-full antialiased text-zinc-800 leading-normal selection:bg-primary-100 selection:text-primary-700 dark:bg-zinc-900 bg-white dark:text-zinc-50 dark:selection:bg-zinc-500/40 dark:selection:text-zinc-200',
      corgie: 'h-screen antialiased text-neutral-800 dark:text-neutral-50 dark:bg-neutral-900 bg-neutral-50'
    }
  end
end
