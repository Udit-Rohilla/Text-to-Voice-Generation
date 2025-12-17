ActiveSupport.on_load(:action_view) do
  handler = ActionView::Template::Handlers::ERB

  unless handler.const_defined?(:ENCODING_FLAG)
    handler.const_set(:ENCODING_FLAG, '[+-]'.freeze)
  end
end
