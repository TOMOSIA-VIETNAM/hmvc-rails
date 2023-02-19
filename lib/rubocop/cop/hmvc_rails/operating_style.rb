# frozen_string_literal: true

module RuboCop
  module Cop
    module HmvcRails
      class OperatingStyle < RuboCop::Cop::Base
        def on_class(node)
          class_name = node.children.first.children.last.to_s
          return if class_name.end_with?("Operation")

          add_offense(node, message: "The operation name does not match the desired format")
        end

        def on_def(node)
          return unless node.children.first == :call

          node.body.to_a.compact.each do |ast|
            next if ast.is_a?(Symbol) && (ast.to_s.start_with?("step_") || ats.to_s == "super")

            next if ast.is_a?(RuboCop::AST::SendNode) &&
                    (ast.children.last.to_s.start_with?("step_") || ast.children.last.to_s == "super")

            add_offense(node, message: "Method works in \"call\" without prefix \"step_\"")
          end
        end
      end
    end
  end
end
