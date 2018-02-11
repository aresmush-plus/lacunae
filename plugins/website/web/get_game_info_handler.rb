module AresMUSH
  module Website
    class GetGameInfoRequestHandler
      def handle(request)
        enactor = request.enactor

        error = WebHelpers.check_login(request, true)
        return error if error
        
        
        disabled = {}
        Global.read_config('plugins', 'disabled_plugins').each do |p|
          disabled[p] = true
        end
        
        search_file_path = File.join(AresMUSH.game_path, 'text', 'searchbox.txt')
        if (File.exists?(search_file_path))
          searchbox_text = File.read(search_file_path)          
        else
          searchbox_text = nil
        end
        
        active_scenes = Scene.all.select { |s| !s.completed }
        if (enactor)
          unread_scenes = active_scenes.select { |s| s.participants.include?(enactor) && Scenes.can_access_scene?(enactor, s) && s.is_unread?(enactor) }
          .map { |s| {
            title: s.date_title,
            id: s.id
          }}
        else
          unread_scenes = []
        end
        
        {
          type: 'game',
          id: 1,
          name: Global.read_config('game', 'name'),
          host: Global.read_config('server', 'hostname'),
          port: Global.read_config('server', 'port'),
          website_tagline: Global.read_config('website', 'website_tagline'),
          website_welcome: WebHelpers.format_markdown_for_html(Global.read_config('website', 'website_welcome')),
          onlineCount: Global.client_monitor.logged_in.count,
          ictime: ICTime.ic_datestr(ICTime.ictime),
          scene_start_date: ICTime.ictime.strftime("%Y-%m-%d"),
          unread_scenes_count: unread_scenes.count,
          date_entry_format: Global.read_config("datetime", 'date_entry_format_help').upcase,
          disabled_plugins: disabled,
          who_count: Global.client_monitor.logged_in.count,
          scene_count: active_scenes.count,
          roster_enabled: Idle.roster_enabled?,
          reboot_required: File.exist?('/var/run/reboot-required'),
          searchbox_text: searchbox_text.blank? ? nil : searchbox_text
        } 
      end
    end
  end
end