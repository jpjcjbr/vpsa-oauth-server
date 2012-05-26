module Lelylan
  module Rescue
    module Helpers

      def bson_invalid_object_id(e)
        print '<<<<<<<<<<<<<<<<<<<<<< bson_invalid_object_id'
        redirect_to root_path, alert: "Resource not found."
      end

      def json_parse_error(e)
        print '<<<<<<<<<<<<<<<<<<<<<< json_parse_error'
        redirect_to root_path, alert: "Json not valid"
      end

      def mongoid_errors_invalid_type(e)
        print '<<<<<<<<<<<<<<<<<<<<<< mongoid_errors_invalid_type'
        redirect_to root_path, alert: "Json values is not an array"
      end

    end
  end
end
