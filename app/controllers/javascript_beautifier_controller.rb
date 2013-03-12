class JavascriptBeautifierController < ApplicationController
  def beautify
    begin
      @javascript, @source_map = JavascriptBeautifier.fetch_and_beautify(params[:url])

      # formatter = Rouge::Formatters::HTML.new(:css_class => 'highlight')
      # lexer = Rouge::Lexers::Javascript.new
      # @javascript = formatter.format(lexer.lex(@javascript))

    rescue Exception => e
      @source_map = "{}"
      @error = e
    end

    render :layout => false
  end
end
