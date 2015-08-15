class Risebox::Notify::Message

  def initialize
  end

  def generate tokens, title, state, state_params
    {
      tokens: [
        tokens.pluck(:token).join(',')
      ],
      notification: {
        alert: title,
        ios: {
          badge: 1,
          sound: "ping.aiff",
          expiry: 1.day.from_now.to_i,
          priority: 10,
          contentAvailable: true,
          payload: payload(state, state_params)
        },
        android: {
          collapseKey: "foo",
          delayWhileIdle: true,
          timeToLive: 1.day.minutes.to_i,
          payload: payload(state, state_params)
        }
      }
    }.to_json
  end

  def status message_id
    Risebox::Client::IonicPushSession.new.message_status message_id
  end

private

  def payload state, state_params
    { '$state' => state,
      '$stateParams' =>  state_params.to_json }
  end

end