saving = {}



saving.getScores = function ()
    local text = love.filesystem.read("scores")
    if text == "" or not text then
        return {}
    end
    local scores = bitser.loads(text)
    return scores
end

saving.setScores = function (scores)
    local text = bitser.dumps(scores)
    love.filesystem.write('scores', text)
end