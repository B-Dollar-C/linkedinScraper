class BasicDataService

	def self.overview(profile_url)
      user_data = {}
      begin
        browser = Watir::Browser.new :chrome, headless: true#, options: { binary: '/usr/bin/google-chrome' }
        browser.goto("https://linkedin.com")
        sleep(5)
        browser.text_field(id: 'session_password').set("Ravimani@123")
        browser.text_field(id: 'session_key').set("manitripathiravi007@gmail.com")
        browser.button(data_id: 'sign-in-form__submit-btn').click
        browser.goto(profile_url)
        sleep(5)
        browser_result = browser.section(class: 'artdeco-card ember-view pv-top-card').wait_until(&:present?)
        doc = Nokogiri::HTML(browser_result.inner_html)
        profile_name = doc.at_css('.pv-text-details__title h1').text.strip
        linkedin_tags = doc.at_css('.text-body-medium.break-words').text.strip rescue ""
        connections = doc.at_css('.link-without-visited-state .t-bold, .t-black--light .t-bold').text.strip
        profile_pic = doc.at_css('.pv-top-card__non-self-photo-wrapper.ml0 img, .profile-photo-edit.pv-top-card__edit-photo img')['src'] rescue ""
        bg_pic = doc.at_css('.profile-background-image__image-container img')['src'] rescue ""  

        connect_url = browser.goto("#{profile_url}overlay/contact-info/")
        sleep(5)
        doc2 = Nokogiri::HTML(browser.html)
        div_elements = doc2.css('div.pv-profile-section__section-info.section-info')
        href_values = div_elements.css('a').map { |link| link['href'] }
        href_texts = div_elements.css('a').map { |link| link.text.strip }
        phone = (doc2.at_css('section.pv-contact-info__contact-type.ci-phone')).at_css('.t-14.t-black.t-normal').text.strip rescue ""
        metadata = {}
        href_texts.each_with_index do |text, index|
           metadata["#{text}"] = href_values[index]
        end
        user_data = {
        	profile_url: profile_url,
        	profile_name: profile_name,
        	linkedin_tags: linkedin_tags,
        	connections: connections,
        	profile_pic: profile_pic,
        	bg_pic: bg_pic,
        	connect_url: connect_url,
        	phone: phone,
        	metadata: metadata
        }
     rescue Exception => e
      puts e
      return user_data
     end
    end
end
