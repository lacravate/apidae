# encoding: utf-8

require 'base64'

# I didn't want to package any template. I wanted a rendering stuff available
# with a mere require. I also wanted this gem to be free from any templating
# system dependency.
# So i shamelessly devised a little something to do the job. In the end, as much
# as a bit preposterous, it was fun to do.

module Apidae

  # i know wax is the fabric primarily used by the honey bees and not
  # forcibly, if not at all, by the other apidae. But it sounded cooler
  # and shorter
  module Wax

    # basic HTML constructs (packed in base64), along with the receipes to stuff
    # contents in them. If no named part is given, receipe applies to construct
    # body
    MOLDS = {
      Assemblage: [
        "PGh0bWw+CiAgPGhlYWQ+CiAgICA8dGl0bGU+CiAgICAgIEFwaWRhZSBIaXZl\nIC0gCiAgICA8L3RpdGxlPgogIDwvaGVhZD4KICA8Ym9keT4KCiAgPC9ib2R5\nPgo8L2h0bWw+Cg==\n",
        { body: /(body>)(.*?)(<\/body)/m, title: /(title>)(.*?)(<\/title)/m, head: /(head>)(.*?)(<\/head)/m }
      ],
      Style:      [ "PHN0eWxlPgpib2R5e21hcmdpbjowOyBwYWRkaW5nOjA7IGZvbnQtc2l6ZTox\nM3B4OyBmb250LWZhbWlseTpHZW9yZ2lhLCAiVGltZXMgTmV3IFJvbWFuIiwg\nVGltZXMsIHNlcmlmOyBjb2xvcjojNjY2NjY2OyBiYWNrZ3JvdW5kLWNvbG9y\nOiNGRkZGRkY7IH0KaW1ne2Rpc3BsYXk6YmxvY2s7IG1hcmdpbjowOyBwYWRk\naW5nOjA7IGJvcmRlcjpub25lO30KYXtvdXRsaW5lOm5vbmU7IHRleHQtZGVj\nb3JhdGlvbjpub25lOyBjb2xvcjojMDU5QkQ4OyBiYWNrZ3JvdW5kLWNvbG9y\nOiNGRkZGRkY7fQpsaXtsaXN0LXN0eWxlLXR5cGU6bm9uZTsgbWFyZ2luOjA7\nIHBhZGRpbmc6MDt9CnVseyBwYWRkaW5nLWxlZnQ6IDIwcHg7fQo8L3N0eWxl\nPgo=\n" ],
      Link:       [ "PGEgaHJlZj0iLy8iPjwvYT4=\n",     [ /(\/)(.*?)(\/)/, /(\/)(.*?)(\")/, /(>)(.*?)(<)/ ] ],
      Image:      [ "PGltZyBzcmM9Ii9yZWFkLyI+\n",     /(\/)(.*?)(\")/ ],
      Text:       [ "PHA+PC9wPg==\n",                 /(>)(.*?)(<)/ ],
      Formated:   [ "PHByZT48L3ByZT4=\n",             /(>)(.*?)(<)/ ],
      List:       [ "PHVsPjwvdWw+\n",                 /(ul>)(.*?)(<\/ul)/ ],
      ListItem:   [ "PGxpPjwvbGk+\n",                 /(>)(.*?)(<)/ ]
    }.freeze

    # for each mold
    MOLDS.each do |name, rules|
      # we define a class derived from String
      wax_class = Class.new(String) do |klass|
        # that has a construct
        klass::CONSTRUCT = Base64.decode64 MOLDS[name].first

        # and normalised receipes. Targeted normalised receipes list is the Hash
        # in Assemblage definition
        (klass::PARTS = (p  = MOLDS[name].last) && (p.is_a?(Hash) ? p : { body: p })).each do |part, pattern|
          # a method for each named part
          define_method part.to_sym do
            tap { @part = part } # that merely sets the part we are 
                                 # going to work on and return self
          end
        end

        def initialize
          # String value as decoded class construct
          super self.class::CONSTRUCT
        end

        def <<(wax)
          # selects the receipe(s) for the select part to work on (or :body as default)
          # each receipe (substitution) is applied with the argument(s) given
          Array(self.class::PARTS[@part || :body]).each { |pattern| sub! pattern, "\\1\\2#{Array(wax).shift}\\3" }
          tap { @part = nil }
        end

      end # end class definition

      # module method to wrap the creation of a new Wax::* class with the
      # content to be pushed
      define_method name.to_s.downcase.to_sym do |*args, &block|
        (wax_class.new << args).tap { |m| block.call(m) unless block.nil? }
      end

      # class has a name now
      const_set name, wax_class
    end

  end

end
