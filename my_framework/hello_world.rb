#hello_world.rb

require_relative 'advice' # loads advice.rb

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {'Content-Type' => 'text/html'}, ['<h2>Hello World!</h2>']]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {'Content-Type' => 'text/html'},
        ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
      ]
    else
      [
        '404',
        {'Content-Type' => 'text/html', 'Content-Length' => '48'},
        ['<html><body><h4>404 Not Found</h4></body></html>']
      ]
    end
  end
end
