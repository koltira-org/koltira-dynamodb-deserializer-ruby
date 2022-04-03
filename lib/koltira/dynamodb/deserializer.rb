# frozen_string_literal: true

require 'bigdecimal'
require 'base64'
require 'stringio'
require 'set'
require_relative "deserializer/version"

module Koltira
  module DynamoDB
    class Deserializer
      class Error < StandardError; end

      def call(data)
        data.transform_values do |value|
          deserialize(value)
        end
      end

      private

      def deserialize(input)
        attr_type, attr_value = input.first

        case attr_type
        when 'N' then BigDecimal(attr_value)
        when 'S' then attr_value
        when 'L'
          attr_value.collect do |item|
            deserialize(item)
          end
        when 'M' then call(attr_value)
        when 'BOOL' then attr_value
        when 'NULL' then nil
        when 'B' then StringIO.new(Base64.decode64(attr_value))
        when 'BS'
          Set.new(
            attr_value.collect do |item|
              StringIO.new(Base64.decode64(item))
            end
          )
        when 'NS'
          Set.new(
            attr_value.collect do |item|
              BigDecimal(item)
            end
          )
        when 'SS'
          Set.new(attr_value)
        else
          raise Error, "Unknown DynamoDB attribute type: #{attr_type}"
        end
      end
    end
  end
end
