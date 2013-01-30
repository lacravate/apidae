# encoding: utf-8

require 'base64'

module Apidae

  # i know wax is the fabric primarily used by the honey bees and not
  # forcibly, if not at all, by the other apidae. But it sounded cooler
  # and shorter
  module Wax
    MOLDS = {
      Assemblage: [
        "PGh0bWw+CiAgPGhlYWQ+CiAgICA8dGl0bGU+CiAgICAgIEFwaWRhZSBIaXZl\nIC0gCiAgICA8L3RpdGxlPgogIDwvaGVhZD4KICA8Ym9keT4KCiAgPC9ib2R5\nPgo8L2h0bWw+Cg==\n",
        { body: /(body>)(.*?)(<\/body)/m, title: /(title>)(.*?)(<\/title)/m, head: /(head>)(.*?)(<\/head)/m }
      ],
      Style:      [ "PHN0eWxlPgpib2R5e21hcmdpbjowOyBwYWRkaW5nOjA7IGZvbnQtc2l6ZTox\nM3B4OyBmb250LWZhbWlseTpHZW9yZ2lhLCAiVGltZXMgTmV3IFJvbWFuIiwg\nVGltZXMsIHNlcmlmOyBjb2xvcjojNjY2NjY2OyBiYWNrZ3JvdW5kLWNvbG9y\nOiNGRkZGRkY7IH0KaW1ne2Rpc3BsYXk6YmxvY2s7IG1hcmdpbjowOyBwYWRk\naW5nOjA7IGJvcmRlcjpub25lO30KYXtvdXRsaW5lOm5vbmU7IHRleHQtZGVj\nb3JhdGlvbjpub25lOyBjb2xvcjojMDU5QkQ4OyBiYWNrZ3JvdW5kLWNvbG9y\nOiNGRkZGRkY7fQpsaXtsaXN0LXN0eWxlLXR5cGU6bm9uZTsgbWFyZ2luOjA7\nIHBhZGRpbmc6MDt9CnVseyBwYWRkaW5nLWxlZnQ6IDIwcHg7fQo8L3N0eWxl\nPgo=\n" ],
      Link:       [ "PGEgaHJlZj0iLy8iPjwvYT4=\n",     [ /(\/)(.*?)(\/)/, /(\/)(.*?)(\")/, /(>)(.*?)(<)/ ] ],
      Image:      [ "PGltZyBzcmM9Ii9tZWRpYS8iPg==\n", /(\/)(.*?)(\")/ ],
      Text:       [ "PHA+PC9wPg==\n",                 /(>)(.*?)(<)/ ],
      Formated:   [ "PHByZT48L3ByZT4=\n",             /(>)(.*?)(<)/ ],
      List:       [ "PHVsPjwvdWw+\n",                 /(ul>)(.*?)(<\/ul)/ ],
      ListItem:   [ "PGxpPjwvbGk+\n",                 /(>)(.*?)(<)/ ]
    }.freeze

    MOLDS.each do |name, rules|
      wax_class = Class.new(String) do |klass|
        klass::CONSTRUCT = Base64.decode64 MOLDS[name].first
        (klass::PARTS = (p  = MOLDS[name].last) && (p.is_a?(Hash) ? p : { body: p })).each do |part, pattern|
          define_method part.to_sym do
            tap { @part = part }
          end
        end

        def initialize
          super self.class::CONSTRUCT
        end

        def <<(wax)
          Array(self.class::PARTS[@part || :body]).each { |pattern| sub! pattern, "\\1\\2#{Array(wax).shift}\\3" }
          tap { @part = nil }
        end

      end

      define_method name.to_s.downcase.to_sym do |*args, &block|
        (wax_class.new << args).tap { |m| block.call(m) unless block.nil? }
      end

      const_set name, wax_class
    end

  end

end
