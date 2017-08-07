# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

exec = require('child_process').exec

module.exports = (robot) ->

   robot.hear /help/i, (res) ->
     res.send "Chat as service for query k8s status\n
     ```
     k8s get LABEL RESOURCE \n
     k8s describe LABEL RESOURCE \n
     k8s history DEPLOYMENY \n
     k8s log PODS CONTAINER \n
     # Example \n
     k8s get api=scoke pods \n
     k8s log scoke-api-server-2144674038-lhbt6 scoke \n
     k8s history scoke-api-server
     ```
     "

   robot.respond /k8s (get|describe) (.*) (.*)/, (res) ->
     command = "kubectl #{res.match[1]} #{res.match[3]} -l #{res.match[2]}"

     robot.logger.debug "asking #{command}"

     exec command, (error, stdout, stderr) ->
      if error?
        robot.logger.error error
        res.reply "Error with command : #{command}"
      else
        res.reply "\n```#{stdout}```"

    robot.respond /k8s log (.*) (.*)/, (res) ->
     command = "kubectl log #{res.match[1]} -c #{res.match[2]} --limit-bytes=2048"

     robot.logger.debug "asking #{command}"

     exec command, (error, stdout, stderr) ->
      if error?
        robot.logger.error error
        res.reply "Error with command : #{command}"
      else
        res.reply "\n```#{stdout}```"

    robot.respond /k8s history (.*)/, (res) ->
     command = "kubectl rollout history deploy #{res.match[1]}"

     robot.logger.debug "asking #{command}"

     exec command, (error, stdout, stderr) ->
      if error?
        robot.logger.error error
        res.reply "Error with command : #{command}"
      else
        res.reply "\n```#{stdout}```"

  ### robot.respond /help\s*(.*)?$/i, (res) ->
     res.reply "That means nothing to me anymore. Perhaps you meant `docs` instead?"
     return

   robot.respond /open the (.*) doors/i, (res) ->
     doorType = res.match[1]
     if doorType is "pod bay"
       res.reply "I'm afraid I can't let you do that."
     else
       res.reply "Opening #{doorType} doors"

   robot.hear /I like pie/i, (res) ->
     res.emote "makes a freshly baked pie"

   lulz = ['lol', 'rofl', 'lmao']

   robot.respond /lulz/i, (res) ->
     res.send res.random lulz

   robot.topic (res) ->
     res.send "#{res.message.text}? That's a Paddlin'"###

  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
