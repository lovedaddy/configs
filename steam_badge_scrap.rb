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

class Trader
  attr_reader :steam_id, :games_list, :have_excludes, :wants_include, :have_dups_only, :cards_hash
  
  def initialize(steam_id, game_list, have_excludes, want_includes, force_rebuild_card_cache)
    @steam_id = steam_id
    @game_list = game_list
    @have_excludes = have_excludes
    @want_includes = want_includes
    @have_dups_only = false
    @browser = ""
    @cards_hash = Hash.new()
    @output = String.new()
    @forum_intro = String.new()
    @force_rebuild_card_cache = force_rebuild_card_cache
  end
 
  def populate_card_hash
    if card_cash_rebuild_need?
      self.rebuild_card_cache()
    else
      self.get_card_cache
    end
  end

  def card_cash_rebuild_need?
    if not File.exists?("card_cache.json") or @force_rebuild_card_cache
      return true
    else
      return false
    end
  end

  def get_card_cache
    @cards_hash = JSON.parse(File.read("card_cache.json")).to_h
  end

  def rebuild_card_cache()
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["permissions.default.image"] = 2
    @browser = Watir::Browser.new(:firefox, :profile => profile)
    @game_list.each do |game_id|
      @browser.goto("http://steamcommunity.com/id/#{@steam_id}/gamecards/#{game_id}/")
      self.populate_card_stats()
    end
    File.open("card_cache.json", 'w') {|f| f.write(@cards_hash.to_json) }
    @browser.close
  end

  def populate_card_stats()
    current_game = @browser.elements(:class => "profile_small_header_location")[1].text

    @cards_hash[current_game] = []

    badge_grid = @browser.element(:class => "badge_detail_tasks")

    badges = badge_grid.elements(:class => "badge_card_set_card")

    badges.each do |badge|
      badge_text = badge.elements(:class => "badge_card_set_text")
      badge_details =  badge_text[0].text.split("\n")

      card_index = badge_text[1].text[0].to_i

      card_hash = Hash.new()
      
      if badge_details.length > 1
        card_hash = {"badge name" => badge_details[1], "quantity" => badge_details[0][1...-1].to_i}
      else
        card_hash = {"badge name" => badge_details[0], "quantity" => 0}
      end

      @cards_hash[current_game][card_index - 1] = card_hash
    end
  end

  def have_for_trade(games, dups_only = false)
    i = 0
    @output << "Have for trade:\n\n"
    @cards_hash.each do |game, cards|
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
    @cards_hash.each do |game, cards|
      if games.include?(game)
        @output << "#{game}:\n"
        cards.each do |card_details|
          @output << " - #{card_details["badge name"]}\n" if card_details["quantity"] == 0
        end
        @output << "\n"
      end
    end
  end

  def add_intro(intro = "")
    intro = File.read("trade_intro.txt") if File.exists?("trade_intro.txt")
    @output << intro
  end

  def write_output
    File.open("trade_n.txt", 'w') {|f| f.write(@output) }
  end

end


@wants = ["System Shock 2"]
@exclude = []
@dups_only = false
do_rebuild_card_cache = false


t = Trader.new("ql6wlld", @game_ids, @excludes, @wants, do_rebuild_card_cache)

t.populate_card_hash
t.add_intro()
t.have_for_trade(@exclude, @dups_only)
t.wants_from_trade(@wants)
t.write_output

puts "Total games with trading cards: #{t.cards_hash.length}"
