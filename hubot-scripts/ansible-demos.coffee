# Description:
#    start jenkins-script jobs with hubot patterns

module.exports = (robot) ->
  robot.respond ///
        demo
        (?:[\s]+)  # required whitespace
        ([\S]+)    # the demo playbook I'd like to run
  ///i, (msg) ->
    params =
      PLAYBOOK: "#{msg.match[1]}.yml"
    if msg.message.text.match('-snippet')
      params.PLUGIN = "snippet.py"
    if msg.message.text.match('-update')
      params.PLUGIN = "update.py"
    robot.emit "jenkins-script", "demo-ansible.sh", params, msg
