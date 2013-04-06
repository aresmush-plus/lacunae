require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe WhoChar do
      before do
        container = mock(Container)
        @client = mock(Client)
        @config_reader = mock(ConfigReader)
        container.stub(:config_reader) { @config_reader }
        @formatter = WhoChar.new(@client, container)
      end

      describe :template do
        it "should use the char template" do
          @config_reader.stub(:config) {{ "who" => { "char_template" => "template"} }}
          @formatter.template.should eq "template"
        end
      end

      describe :render_default do
        it "should render with the format string" do
          @config_reader.stub(:config) {{ "who" => { "char_template" => "template"} }}
          @formatter.should_receive(:render).with("template")
          @formatter.render_default
        end
      end
      
      describe :fields do
        it "should define the default fields" do
          @client.stub(:name) { "NAME" }
          @client.stub(:idle) { "IDLE" }
          @client.stub(:char) {  { "status" => "STAT" } }
          
          @formatter.name.should eq "NAME                "
          @formatter.idle.should eq "IDLE "
          @formatter.status.should eq "STAT "
        end
      end
      
    end
  end
end