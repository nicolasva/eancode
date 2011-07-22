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
		end

		def run
		        url_web = @url_web + @options[:domain]
		        @domain = @options[:domain].scan(/^([\w\d\.\-]+).*$/)[0][0]	
			
			#result_line = routing_web(url_web)
			
			#result_line.each_line{ |line|
			#	unless line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/).empty?
			#		tab_url = line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/) 
			#		0.upto(tab_url.length-1){ |i|
			#			img_eancode?(tab_url[i][0])			
			#			link_href?(tab_url[i][0])
			#		}
			#	end
			#}
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

		    unless @tab_url_pass.include?(url_web)
		      result_line = routing_web(url_web)

		      result_line.each_line{ |line|	
				unless line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/).empty?
					tab_url = line.strip.scan(/<\s*a\s+[^>]*href\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/) 
					0.upto(tab_url.length-1){ |i|
						img_eancode?(tab_url[i][0])
						link_href?(tab_url[i][0])			
					}
				end
		      }
		      @tab_url_pass.push(url_web)
		    end
		end

		def img_eancode?(url)
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
	
		      result_line = routing_web(url_web)

		      result_line.each_line{ |line|
			        line_src_img = line.strip.scan(/<\s*img\s+[^>]*src\s*=\s*[\"‘]?([^\"' >]+)[\"‘ >]/)
		      		unless line_src_img.empty?
					tab_url = line_src_img 
					0.upto(tab_url.length-1){ |i|
				             #puts tab_url[i][0]
					     puts tab_url[i][0].strip.scan(/.{1,}\/|([0-9])/).join() unless tab_url[i][0].strip.scan(/.{1,}\/|([0-9])/).join().empty? || tab_url[i][0].strip.scan(/.{1,}\/|([0-9])/).join().length != 13
					     puts tab_url[i][0].strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/)[0][0].scan(/[0-9]/).join() unless tab_url[i][0].strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/).nil? || tab_url[i][0].strip.scan(/^.{1,}\/(.{1,}\/.{1,})\.(jpg|bmp|png|PNG|JPG|BMP)$/).empty? || tab_url[i][0].scan(/.{1,}\/(.{1,}\/.{1,}).jpg/)[0][0].scan(/[0-9]/).join.length != 13
					}
				end
		      }
		end

		private
		def routing_web(url_web)	
 		      url = URI.parse(url_web)	
		      res = Net::HTTP.start(url.host, url.port) { |http|
		      		http.get("/")
		      }
	      	      res.body	      
		end

	end
end
