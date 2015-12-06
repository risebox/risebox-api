class Risebox::Notify::Message

  def initialize
  end

  def generate tokens, title, state, state_params
    {
      tokens: tokens.pluck(:token),
      notification: {
        alert: title,
        ios: {
          badge: 1,
          sound: "ping.aiff",
          expiry: expirity.from_now.to_i,
          priority: 10,
          contentAvailable: 1,
          payload: payload(state, state_params)
        },
        android: {
          collapseKey: "foo",
          delayWhileIdle: true,
          timeToLive: expirity.to_i,
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

  def expirity
    1.hour
  end

end