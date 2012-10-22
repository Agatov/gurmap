Rails.application.config.middleware.use OmniAuth::Builder do

  provider :vkontakte, '3036832', 'd3kg1Zf7gQ7wd7Lbbs6R', {
      scope: "notify,friends,photos,offline"
  }


  #provider :facebook, '344870455552051', '5e499918380d1ef2f091630febe818bb'
  #provider :odnoklassniki, '43075328', '281C878A28D072B52200F79A', :public_key => 'CBAIECJDABABABABA'
  #provider :mailru, '666078', '6c6f078990fbc064c05e0c4b7c28a80a'
  #provider :twitter, 'xi149D5q6CbEk9zhwZ2Y6w', 'J8xHncEqVSsHJF5zogANrYqinLmVzIe44sMUD0ftU'
end