# frozen_string_literal: true

module RuboCop
  module Cop
    module HmvcRails
      class FormalStyle < RuboCop::Cop::Base
        def on_class(node)
          class_name = node.children.first.children.last.to_s
          return if class_name.end_with?("Form")

          add_offense(node, message: "The form filename does not match the desired format")
        end
      end
    end
  end
end
