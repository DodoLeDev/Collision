module Collision::Compare
  extend self

  def init
    TOOL_COMPARE_BUTTON.clicked_signal.connect do
      TOOL_COMPARE_FILE_CHOOSER_NATIVE.show
    end

    TOOL_COMPARE_FILE_CHOOSER_NATIVE.response_signal.connect do |response|
      next unless response == -3
      LOGGER.debug { "Begin comparing tool" }

      TOOL_COMPARE_BUTTON_SPINNER.visible = true
      TOOL_COMPARE_BUTTON_IMAGE.visible = false
      TOOL_COMPARE_BUTTON.remove_css_class("success")
      TOOL_COMPARE_BUTTON.remove_css_class("error")

      TOOL_COMPARE_BUTTON_LABEL.label = TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.not_nil!.path.not_nil!.basename.to_s
      Collision::Checksum.spawn do
        compareFileSHA256 = Collision::Checksum.calculate("sha256", TOOL_COMPARE_FILE_CHOOSER_NATIVE.file.not_nil!.path.to_s)
        result = CLIPBOARD_HASH["SHA256"] == compareFileSHA256
        classes = Collision::Feedback.class(result)

        sleep 500.milliseconds
        TOOL_COMPARE_BUTTON_SPINNER.visible = false
        TOOL_COMPARE_BUTTON_IMAGE.visible = true
        TOOL_COMPARE_BUTTON_IMAGE.icon_name = Collision::Feedback.icon(result)
        TOOL_COMPARE_BUTTON.add_css_class(classes[:add])
        TOOL_COMPARE_BUTTON.remove_css_class(classes[:remove])

        LOGGER.debug { "Finished comparing tool" }
      end
    end
  end
end
