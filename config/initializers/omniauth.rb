Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal,
           "AUJbbhB_O2u8qhA3gC2PMozDz9oCvdB9NK--dQsf3iXUk9dKMsGaXp2LVhKG",
           "EENB7xBE6tmIwYpbtM94dlXx8JDLo35BnH9DXM4BLmvKjqrRkXFO9JcqxGtV",
           sandbox: true,
           scope: "openid email"
end