
Gem::Specification.new do |s|
   s.required_ruby_version = '>= 1.8.0'
   s.name = %q{monetdb-sql}
   s.version = "1.0"
   s.date = %q{2016-03-02}
   s.authors = ["G Modena", "R Koopmanschap"]
   s.email = "info@monetdb.org"
   s.license = "MPL-2.0"
   s.summary = %q{Pure Ruby database driver for MonetDB/SQL}
   s.homepage = %q{http://www.monetdb.org/}
   s.description = %q{Pure Ruby database driver for the MonetDB/SQL columnar database management system}
   s.files = ["lib/MonetDB.rb", "lib/MonetDBConnection.rb", "lib/MonetDBData.rb", "lib/MonetDBExceptions.rb", "lib/hasher.rb"]
   s.has_rdoc = true
   s.require_path = './lib'
   # placeholder project to avoid warning about not having a rubyforge_project
   s.rubyforge_project = "nowarning"
end
