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
            next if special_node?(ast.class)

            next if ast.is_a?(Symbol) && valid?(ast.to_s)

            next if ast.is_a?(RuboCop::AST::SendNode) && valid?(ast.children.last.to_s)

            add_offense(node, message: "Method works in \"call\" without prefix \"step_\"")
          end
        end

        private

        def special_node?(node_name)
          [
            RuboCop::AST::Node,
            RuboCop::AST::IfNode,
            RuboCop::AST::IntNode,
            RuboCop::AST::ArgsNode,
            RuboCop::AST::BlockNode,
            RuboCop::AST::YieldNode,
            RuboCop::AST::SuperNode,
            RuboCop::AST::ReturnNode,
            RuboCop::AST::ResbodyNode
          ].include?(node_name)
        end

        def valid?(text)
          %w[step_ transaction].any? { |keyword| text.start_with?(keyword) }
        end
      end
    end
  end
end
