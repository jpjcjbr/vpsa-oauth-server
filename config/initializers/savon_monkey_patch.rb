require "savon"

module Savon
  module SOAP
    class XML

      attr_accessor :header_attributes

      def to_xml
        @xml ||= tag(builder, :Envelope, complete_namespaces) do |xml|
          # adds the header_attributes:
          tag(xml, :Header, header_attributes) { xml << header_for_xml } unless header_for_xml.empty?

          if input.nil?
            tag(xml, :Body)
          else
            tag(xml, :Body) { xml.tag!(*add_namespace_to_input) { xml << body_to_xml } }
          end
        end
      end

    end
  end
end