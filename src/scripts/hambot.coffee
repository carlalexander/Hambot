# Description
#   Hubot script to interact with Hamlet
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_HAMLET_URL
#
# Commands:
#   hubot what can you deploy? - Gets you the list of deployment projects
#
# Author:
#   carlalexander

hamlet_url = process.env.HUBOT_HAMLET_URL

getRequest = (msg, path, callback) ->
  msg.http("#{hamlet_url}#{path}")
    .headers("Content-Type": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)

module.exports = (robot) ->
  robot.respond /(what can you deploy\?)/i, (msg) ->
    getRequest msg, "/deploy", (err, res, body) ->
      if res.statusCode == 200
        response = JSON.parse body
        deployList = "I can deploy the shit out of!\n\n"
        for name, deploy of response
          deployList += "#{name} : #{deploy.description}\n"

        msg.send deployList
      else
        msg.send "WELP! Time to move to Mexico!"