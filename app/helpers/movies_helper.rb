module MoviesHelper
    def total_gross(movie)
        if(movie.flop?)
            "Flop!"
        else
            number_to_currency(movie.total_gross, precision:0)
        end
    end

    def year_of(movie)
        movie.released_on.year
    end

    def avg_stars(movie)
        if movie.average_stars.nil?
            content_tag(:strong, "No reviews")
        else
            "*" * movie.average_stars.round
        end
    end

end