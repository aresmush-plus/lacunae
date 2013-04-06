require_relative "../../plugin_test_loader"

module AresMUSH
  module Login
    describe LoginEvents do
      before do
        AresMUSH::Locale.stub(:translate).with("login.announce_char_connected", { :name => "Bob" }) { "announce_char_connected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_disconnected", { :name => "Bob" }) { "announce_char_disconnected" }
        AresMUSH::Locale.stub(:translate).with("login.announce_char_created", { :name => "Bob" }) { "announce_char_created" }
        AresMUSH::Locale.stub(:translate).with("login.welcome") { "welcome" }
        
        @client_monitor = double(ClientMonitor)
        container = double(Container)
        container.stub(:client_monitor) { @client_monitor }
        @client = double(Client)
        @client.stub(:name) { "Bob" }
        @login_events = LoginEvents.new(container)
      end
      
      describe :on_char_connected do
        it "should announce the char" do
          @client.stub(:emit_success) {}
          @client_monitor.should_receive(:emit_all).with("announce_char_connected")
          @login_events.on_char_connected(:client => @client)
        end
        
        it "should send the welcome text to the connecting char" do
          @client_monitor.stub(:emit_all) {}
          @client.should_receive(:emit_success).with("welcome")
          @login_events.on_char_connected(:client => @client)          
        end        
      end
      
      describe :on_char_created do
        it "should announce the char" do
          @client_monitor.should_receive(:emit_all).with("announce_char_created")
          @login_events.on_char_created(:client => @client)
        end
      end
      
      describe :on_char_disconnected do
        it "should announce the char" do
          @client_monitor.should_receive(:emit_all).with("announce_char_disconnected")
          @login_events.on_char_disconnected(:client => @client)
        end
      end
    end
  end
end