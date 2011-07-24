#!/usr/bin/ruby

module CodeEan
	VERSION = '0.0.1'

	class ExecBrowser
		def initialize
			@options = parse_opts
			abort("Domain name with map page not specify") unless @options[:domain]
			#@options[:path] = '/' unless @options[:path]
			@url_web = "http://"
			@domain = ""
			@tab_url_pass = Array.new
			@tab_img_pass = Array.new
		end

		def run
		        url_web = @url_web + @options[:domain]
		        #@domain = @options[:domain].scan(/^([\w\d\.\-]+).*$/)[0][0]	
			uri = URI.parse(url_web)
			@domain = uri.host
			link_href?(url_web)
		end

		def parse_opts
			options = Hash.new
			opts = OptionParser.new

			opts.banner = "Can you enter with argument !!!!"

			opts.on('-d', '--domain domain', 'Address with map page') { |d| options[:domain] = d }
			opts.on('-V', '--version', 'Look the version') { self.version; exit }
			opts.parse(ARGV)
			options
		end

		protected
		def version
			puts "EANcode #{VERSION}"
		end

		def link_href?(url)
		   unless @tab_url_pass.include?(http_www_domain?(url))
		      @tab_url_pass.push(http_www_domain?(url).to_s.strip)
		      #puts http_www_domain?(url)
		      #img_eancode?(url) 
	             if routing_web(http_www_domain?(url)) != false
		      result_line = routing_web(http_www_domain?(url))

		      tab_url = result_line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)
		      #puts result_line.chop.to_s.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)
		   #unless @tab_url_pass.include?(http_www_domain?(url))
		      #@tab_url_pass.push(http_www_domain?(url))
		      #result_line.each_line{ |line|	
				unless tab_url.empty?
		#			tab_url = line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)[0] 
		#			puts tab_url
					7.upto(tab_url.length-1){ |i|
		    			   unless @tab_url_pass.include?(tab_url[i].to_s.strip)
						img_eancode?(tab_url[i].to_s.strip)
						link_href?(tab_url[i].to_s.strip)		
					   	@tab_url_pass.push(tab_url[i].to_s.strip)
					   end	
					}
				end
		 #     }
		    end
		   end
		end

		def img_eancode?(url)
		 #unless @tab_img_pass.include?(http_www_domain?(url))
		   if routing_web(http_www_domain?(url)) != false
		      result_line = routing_web(http_www_domain?(url))


		      tab_url_img = result_line.strip.scan(/<\s*img\s+[^>]*src\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)
		   #unless @tab_url_pass.include?(http_www_domain?(url))
		      #puts url
		      #link_href?(http_www_domain?(url))
		      #result_line.each_line{ |line|
		      #	        line_src_img = line.strip.scan(/<\s*img\s+[^>]*src\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)[0]
		      #		unless line_src_img.nil?
		      #			tab_url = line_src_img 
		 		     unless tab_url_img.empty?
		      			0.upto(tab_url_img.length-1){ |i|
					   #@tab_img_pass.push(tab_url_img[i])
		      			   unless @tab_img_pass.include?(tab_url_img[i].to_s.strip)
				 	     #puts tab_url_img[i].to_s
		      			     puts tab_url_img[i].to_s.strip.scan(/.{1,}\/|([0-9])/).join() unless tab_url_img[i].to_s.strip.scan(/.{1,}\/|([0-9])/).join().empty? || tab_url_img[i].to_s.strip.scan(/.{1,}\/|([0-9])/).join().length != 13
		      			     puts tab_url_img[i].to_s.strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/)[0][0].scan(/[0-9]/).join() unless tab_url_img[i].to_s.strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/).nil? || tab_url_img[i].to_s.strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/).empty? || tab_url_img[i].to_s.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/)[0][0].scan(/[0-9]/).join.length != 13
					   
		      			     @tab_img_pass.push(tab_url_img[i].to_s.strip)
		      			   end
		      			}
				     end
		      #		end
		      #}
		      #@tab_url_pass.push(http_www_domain?(url))
		   #end
		
		   end
		 #end
		end

		private
		def routing_web(url_web)
		      uri = URI.parse(url_web)
		      res = Net::HTTP.get_response(@domain, uri.path.empty? ? "/" : uri.path)
	      	      res.nil? ? false : res.body()	
		end

		def http_www_domain?(url)
			#puts url
			url_domain = url.scan(/^(www|http)(.{1,})$/)
			unless url_domain.empty?
				if url_domain[0][0].to_s == "http"
					url_web = url
				else
					url_web = @url_web + @options[:domain]
				end
			else
				url_web = @url_web + @options[:domain] + "/" + url
			end
			#puts url_web

			url_web
		end

	end
end
