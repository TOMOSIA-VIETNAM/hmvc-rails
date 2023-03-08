# frozen_string_literal: true

module RuboCop
  module Cop
    module HmvcRails
      class OperatingStyle < RuboCop::Cop::Base
        def on_class(node)
          class_name = node.children.first.children.last.to_s
          return if class_name.end_with?("Operation")

          add_offense(node, message: "The operation filename does not match the desired format")
        end

        def on_def(node)
          return unless node.children.first == :call

          node.body.to_a.each do |ats|
            next if ats.children.last.start_with?("step_")

            add_offense(node, message: "Method works in \"call\" without prefix \"step_\"")
          end
        end
      end
    end
  end
end
