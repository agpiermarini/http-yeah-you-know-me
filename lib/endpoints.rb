module Endpoints
  ENDPOINT_MAP =
    {
      'GET/' => :debug_endpoint,
      'POST/' => :debug_endpoint,
      'GET/hello' => :hello_endpoint,
      'GET/datetime' => :datetime_endpoint,
      'GET/shutdown' => :shutdown_endpoint,
      'GET/word_search' => :word_search_endpoint,
      'GET/game' => :game_get_endpoint,
      'POST/game' => :game_post_endoint,
      'POST/start_game' => :start_game_endpoint,
      'POST/force_error' => :force_error,
      'GET/force_error' => :force_error
    }
end
