require 'rexml/document'
include REXML

class EsInput
  def initialize(cfg)
    @xmlfile = File.new(cfg)
  end
  def parse
    Document.new(@xmlfile).elements.collect("inputList/inputConfig/input") do |e|
      {
        name: e.attributes["name"],
        type: e.attributes["type"],
        id: e.attributes["id"],
        value: e.attributes["value"]
      } 
    end
  end
end