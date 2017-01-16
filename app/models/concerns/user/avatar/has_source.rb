class User
  module Avatar

    class Source
      GENERATED = "generated"
      SLACK     = "slack"
      UPLOADED  = "uploaded"
    end

    module HasSource
      extend ActiveSupport::Concern

      def generated_avatar?
        avatar_source == Avatar::Source::GENERATED
      end

      def slack_avatar?
        avatar_source == Avatar::Source::SLACK
      end

      def uploaded_avatar?
        avatar_source == Avatar::Source::UPLOADED
      end

      def avatar_source
        if avatar
          metadata = avatar.is_a?(Hash) ? avatar[:original].metadata : avatar.metadata
          metadata["source"]
        end
      end
    end
  end
end
