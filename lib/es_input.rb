require 'yaml'
require 'rexml/document'
include REXML

class EsInput
  def initialize(es_input_cfg,keybindings )
    @xmlfile = File.new es_input_cfg
    @keybindings = YAML.load_file keybindings
    @inputs = parse_inputs
  end
  def parse_inputs
    Document.new(@xmlfile).elements.collect("inputList/inputConfig/input") do |e|
      {
        name: e.attributes["name"],
        type: e.attributes["type"],
        id: e.attributes["id"],
        value: e.attributes["value"],
        mapping: @keybindings[e.attributes["name"]] || false
      } 
    end
  end
  def mapped_inputs 
    @inputs.select { |input| input[:mapping] }
  end
  def each(&block)
    mapped_inputs.each(&block)
  end
end