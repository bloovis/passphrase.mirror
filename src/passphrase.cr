# Generates a passphrase using the Diceware algorithm.
# Three wordlists are available:
# - EFF long word list (default)
# - Original Diceware word list
# - Beale word list
#
# Build the program using:
#   crystal build passphrase.cr
# Copy the word lists:
#   sudo mkdir -p /usr/local/share/passphrase
#   sudo cp wordlists/*.wordlist /usr/local/share/passphrase

require "option_parser"

class PassPhraseGenerator
  @wordlist : Array(String)
  @list_size = 0
  property entropy = 0.0

  def initialize(filename)
    @wordlist = [] of String
    fullpath = Path.new("/usr/local/share/passphrase", filename)
    #puts "Reading #{fullpath}"
    File.each_line(fullpath) do |line|
      #puts "Word #{line}"
      @wordlist << line.split[1]
    end
    @list_size = @wordlist.size
    @entropy = Math.log2(@list_size.to_f)
    #puts "wordlist size #{@list_size}, entropy = #{@entropy}"
  end

  def roll : String
    return @wordlist[Random::Secure.rand(@list_size)]
  end

  def new_phrase(len : Int32, capitalize : Bool, separator : String) : String
    phrase = ""
    len.times do
      word = roll
      if phrase.size != 0
	phrase = phrase + separator
      end
      if capitalize
	phrase = phrase + word.capitalize
      else
	phrase = phrase + word
      end
    end
    return phrase
  end
end
    
nwords = 6
capitalize = true
nphrases = 1
wordlist = "eff.wordlist"
separator = ""
verbose = false

OptionParser.parse do |parser|
  parser.banner = "Usage: passphrase [args]\nGenerates a passphrase using diceware"
  parser.on("-w SIZE", "--words=SIZE",
	    "Specifies the number of words for the passphrase") { |size| nwords = size.to_i }
  parser.on("-n NUMBER", "--phrases=NUMBER",
	    "Specifies the number of passphrases to generate") { |number| nphrases = number.to_i }
  parser.on("-l", "--lowercase", "Don't capitalize words") { capitalize = false }
  parser.on("-b", "--beale", "Use the Beale word list") { wordlist = "beale.wordlist" }
  parser.on("-d", "--diceware", "Use the Diceware word list") { wordlist = "diceware.wordlist" }
  parser.on("-s", "--short", "Use the EFF short word list") { wordlist = "eff_short.wordlist" }
  parser.on("-a", "--alternate", "Use the alternate EFF short word list") { wordlist = "eff_short2.wordlist" }
  parser.on("-x", "--spaces", "Separate words with spaces") { separator = " " }
  parser.on("-v", "--verbose", "Print extra information") { verbose = true }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
  parser.missing_option do |flag|
    STDERR.puts "ERROR: #{flag} is missing an argument."
    STDERR.puts parser
    exit(1)
  end
end

if ARGV.size > 0
  puts "Ignoring superfluous args #{ARGV.join(' ')}"
end

g = PassPhraseGenerator.new(wordlist)

if verbose
  total_entropy = g.entropy * nwords.to_f
  printf "Generating %d-word passphrase%s with %.1f bits of entropy using %s:\n",
	 nwords, nphrases == 1 ? "" : "s", total_entropy, wordlist
end

nphrases.times do
  puts g.new_phrase(nwords, capitalize, separator)
end
