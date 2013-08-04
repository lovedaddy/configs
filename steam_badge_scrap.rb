#!/usr/bin/ruby
#
require "watir-webdriver"
require "json"
require "yaml"

# steam you fucking POS, why am I logged out everytime.
# I was going to just make an array of all my games and goto them from the main page
# But i seem to be logged out every time
# so this is going to be by hand for now.
# this is fucking lame, juts make an array of all the ids of games you own that have badges.
# FUCKING SUCK

@game_ids = Array.new()

@game_ids = ["550", "620", "730", "207610", "107100", "55230", "4000", "1250", "98200", "201790", "300", "219150", "233740", "220860", "440", "91310", "3830", "211360", "105600", "49600", "204300", "245070", "40800", "238210", "35720", "41800", "225260", "8930", "4920", "212680", "108710", "41070", "200710", "63710", "107200", "214560", "113200", "104900", "72850", "20920", "220"]
#@game_ids = ["550", "620", "238210"]


#b.link(:class => "badge_row_overlay").each do |game|
#  puts game.href
  #  if url.href.include?("gamecards")
  #  if url.href.include?("gamecards") and not url.href.include?("border")
  #
  #  game_ids.push(url.href.split("/")[6])
#end


  def rebuild_card_cache()
    @b = Watir::Browser.new(:firefox)
    @game_ids.each do |id|
      @b.goto("http://steamcommunity.com/id/ql6wlld/gamecards/#{id}/")
      populate_card_stats
    end
    @b.close
  end

  def populate_card_stats()
    game = @b.elements(:class => "profile_small_header_location")[1].text

    @card_stats[game] = []

    badge_grid = @b.element(:class => "badge_detail_tasks")

    badges = badge_grid.elements(:class => "badge_card_set_card")

    badges.each do |badge|
      badge_text = badge.elements(:class => "badge_card_set_text")
      badge_details =  badge_text[0].text.split("\n")

      # puts "badge_details pre fiddle #{badge_details}"

      card_index = badge_text[1].text[0].to_i

      # puts "card index #{card_index}"

      card_hash = Hash.new()
  
      if badge_details.length > 1
        card_hash = {"badge name" => badge_details[1], "quantity" => badge_details[0][1...-1].to_i}
      else
        card_hash = {"badge name" => badge_details[0], "quantity" => 0}
      end

      @card_stats[game][card_index - 1] = card_hash
    end
    File.open("card_cache.json", 'w') {|f| f.write(@card_stats.to_json) }
  end

  def have_for_trade(games, dups_only = false)
    i = 0
    @output << "Have for trade:\n\n"
    @card_stats.each do |game, cards|
      if not games.include?(game)
        @output << "#{game}:\n"
        cards.each do |card_details|
          if dups_only
            @output << " - #{card_details["badge name"]}\n" if card_details["quantity"] > 1
          else
            @output << " - #{card_details["badge name"]}\n" if card_details["quantity"] > 0
          end
          i += 1
        end
        @output << "\n"
      end
    end
    puts "total for trade: #{i}"
  end

  def wants_from_trade(games)
    @output << "Want from trade:\n\n"
    @card_stats.each do |game, cards|
      if games.include?(game)
        @output << "#{game}:\n"
        cards.each do |card_details|
          @output << " - #{card_details["badge name"]}\n" if card_details["quantity"] == 0
        end
        @output << "\n"
      end
    end
  end


  def set_trade_intro(intro = "")
    intro = File.read("trade_intro.txt") if File.exists?("trade_intro.txt")
    @output << intro
  end


@card_stats = Hash.new()

@wants = ["Portal 2", "System Shock 2"]
@exclude = ["Portal 2", "System Shock 2"]
@dups_only = false

@output = String.new()

do_rebuild_card_cache = false

rebuild_card_cache if do_rebuild_card_cache or not File.exist?("card_cache.json")
@card_stats = JSON.parse(File.read("card_cache.json")).to_h

puts "Total games with trading cards: #{@card_stats.length}"

set_trade_intro()
have_for_trade(@exclude, @dups_only)
wants_from_trade(@wants)

File.open("trade.txt", 'w') {|f| f.write(@output) }

