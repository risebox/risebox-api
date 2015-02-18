def send_device_creds_for device
  Risebox::Access::Device.stub(:new).and_return(cred_double = double)
  Risebox::Util::ServiceRescuer.stub(:new).with(cred_double).and_return(cred_service = double('cred_service'))
  cred_service.stub(:device_for_credentials).and_return [true, @device=device]
end