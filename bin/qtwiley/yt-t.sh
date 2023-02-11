#!/bin/bash
#
#   Author:      Twily                                                      2016
#   Description: Pick random artist from the list and plays their youtube query.
#   Requires:    mpv
#   List source: http://en.wikipedia.org/wiki/List_of_ambient_music_artists
#
 
ARTISTS=("2002" "3rd Force" "Philip Aaberg" "William Ackerman" "Acoustic Alchemy" "Adiemus" "Rudy Adrian"
    "Aes Dana" "Aghiatrias" "Air" "Airiel" "The Album Leaf" "Ambeon" "Amethystium" "Autechre" "The American Dollar"
    "Aphex Twin" "Giulio Aldinucci" "Diane Arkenstone" "Ash Ra Tempel" "James Asher" "Atom Heart"
    "Augustine Leudar" "Australis" "Marvin Ayres" "Sara Ayers" "Asura" "William Basinski" "Bad Sector"
    "Wally Badarou" "Bass Communion" "Peter Baumann" "David Bowie (On Low and \"Heroes\")" "Biosphere"
    "Bluetech" "Boards of Canada" "Bohren & der Club of Gore" "Richard Bone" "Booka Shade" "Bonobo"
    "Bowery Electric" "Thom Brennan" "Michael Brook" "Brunette Models" "Buckethead (trance-ambient)"
    "Harold Budd" "Peter Buffett" "Burial" "Burzum (later works)" "Ray Buttigieg" "Blue Foundation"
    "Carbon Based Lifeforms" "Wendy Carlos" "Clifford Carter (member of James Taylor's band)" "Craig Chaquico"
    "Suzanne Ciani" "Clouddead" "Cluster" "Cocteau Twins" "Coil" "B.J. Cole (pedal steel guitarist)" "Colleen"
    "Conjure One, headed by Rhys Fulber" "Controlled Bleeding" "Cusco" "Holger Czukay" "Christ." "Malcolm Dalglish"
    "David Darling" "David Jolley" "Dead Can Dance" "Dead Texan, The" "deadmau5" "Death Ambient" "Death Cube K"
    "Deathprod" "Deep Forest" "Deerhunter" "De Facto (band)" "Delerium" "Constance Demby" "Stuart Dempster"
    "Deuter" "Deutsch Nepal" "DJ Spooky" "Kurt Doles" "Dntel" "Suzanne Doucet" "dreamSTATE" "Kyle Bobby Dunn"
    "Earth" "Earthstar" "Danielle Egnew" "Ludovico Einaudi" "Eluvium" "Emerald Web" "Emeralds" "Justin Emerle"
    "Enigma" "Brian Eno" "Roger Eno" "Enya" "Karlheinz Essl" "Dean Evenson" "Explosions In The Sky" "Don Falcone"
    "Falling Up" "Falling You" "Fantomas" "Ryan Farish" "Christian Fennesz" "The Field" "The Fireman" "Tim Floyd"
    "Jim Fox" "Christopher Franke" "Freescha" "Robert Fripp" "Edgar Froese" "Ben Frost" "Frou Frou"
    "John Frusciante" "Future Sound of London / Amorphous Androgynous" "Peter Gabriel" "Gas" "Philip Glass"
    "Global Communication" "Global Goon" "God Is An Astronaut" "Godspeed You! Black Emperor" "Goldfrapp"
    "Manuel Gottsching" "Nicholas Gunn" "Guru Guru" "Guy Gerber" "Rob Haigh" "Halo Manash" "Peter Hammill"
    "Hammock" "Harmonia" "Jon Hassell" "Imogen Heap" "Tom Heasley" "Tim Hecker" "Michael Hedges" "David Helpling"
    "Higher Intelligence Agency" "Susumu Hirasawa" "Vladimír Hirsch" "Ezekiel Honig" "Hum" "Hwyl Nofio" "Iasos"
    "I.E.M." "In-Existence (Maarten van der Vleuten)" "Inon Zur" "Tetsu Inoue" "Mark Isham" "Irresistible Force"
    "Rafael Anton Irisarri" "Ishq" "Ishvara" "Jacaszek" "Jean Michel Jarre" "Job Karma" "Jonn Serrie"
    "Jónsi & Alex" "Karl Jenkins" "Jeff Johnson" "Jóhann Jóhannsson" "Michael Jones" "Bradley Joseph" "Journeyman"
    "Karunesh" "Kátai Tamás" "Peter Kater" "Kevin Keller (composer)" "Kevin Kern" "Kettel" "Paddy Kingsland"
    "Kitaro" "The KLF" "Thomas Köner" "Kraftwerk" "Andrei Krylov" "Labradford" "Ladytron" "Daniel Lanois"
    "David Lanz" "Laraaji" "Bill Laswell" "Thomas Leer" "Ottmar Liebert" "Lights Out Asia" "Liquid Zen" "Loscil"
    "Lotus Plaza" "Lull" "Luminaria" "Lusine" "Lustmord" "Ray Lynch" "M83" "Maeror Tri" "Main" "Makyo" "Mana ERG"
    "Mannheim Steamroller" "Marconi Union" "Catya Maré" "Mariae Nascenti" "Keiko Matsui" "Max and Harvey"
    "Paul McCandless" "Loreena McKennitt" "Billy McLaughlin" "Mehdi" "Riad Michael" "Michna" "Robert Miles"
    "Robyn Miller" "Mirror System" "Moby" "Moodswings" "The Moon Lay Hidden Beneath a Cloud" "Morgenstern"
    "Rob Mounsey" "Murcof" "Roberto Musci" "Mythos" "R. Carlos Nakai (Native American flutist)" "Pete Namlook"
    "Andy Narell" "Neptune Towers" "Loren Nerell" "Nightnoise" "Nine Inch Nails (Ghosts I-IV, some of The Fragile)"
    "No-Man" "Alva Noto (Carsten Nicolai)" "Numina (Numina/Caul)" "Michael Nyman" "Vidna Obmana" "Obsil" "Ochre"
    "Odd Nosdam" "Patrick O'Hearn" "Mike Oldfield" "Coyote Oldman" "Omar Rodriguez Lopez" "Ombient" "Omni Trio"
    "On! Air! Library!" "Open Canvas" "The Orb" "William Orbit (Strange Cargo series)" "Orbital" "O Yuki Conjugate"
    "Ott (record producer)" "Craig Padilla" "Panda Bear" "Pendulum" "Phish (The Siket Disc in particular)"
    "Pink Floyd" "Pivot" "Plastikman" "Popol Vuh" "Porcupine Tree" "Puff Dragon" "Port Blue" "Rabbit in the Moon"
    "Radiohead (Kid A)" "Radio Massacre International" "Raison D'être" "Raphael" "Red" "Robert Rich" "Terry Riley"
    "Francis Rimbert" "Steve Roach" "Kim Robertson" "Hans-Joachim Roedelius" "Rothko" "Rurutia" "Röyksopp"
    "Saafi Brothers" "Ryuichi Sakamoto" "Karl Sanders" "Bruno Sanfilippo" "Devin Sarno" "Erik Satie"
    "Conrad Schnitzler" "Neal Schon (from Journey)" "Klaus Schulze" "Scorn" "Murat Ses" "Shadowfax" "Jonah Sharp"
    "Shpongle" "Shulman" "Michael Shrieve" "The Sight Below" "Sigur Rós" "Montana Skies" "Spiral Realms"
    "Gary Stadler" "Stars of the Lid" "Stray Ghost" "Michael Stearns" "Solar Fields" "Henrik Takkenberg"
    "Hirokazu Tanaka" "Tangerine Dream" "Team Sleep" "Telefon Tel Aviv" "Mark Templeton" "Terre Thaemlitz"
    "The Necks" "Robert Scott Thompson" "TimeShard" "Amon Tobin" "Devin Townsend" "Troum" "Tuu" "Thom Brennan"
    "Thomas Newman" "Tycho" "Ulrich Schnauss" "Ulver" "Underworld" "Vangelis" "Velvet Cacoon"
    "Luke Vibert (as Wagon Christ)" "Voice of Eye" "Kit Watkins" "Wavestar (with John Dyson)" "Simon Webb"
    "Carl Weingarten" "Steven Wilson" "Windy & Carl" "Paul Winter" "Paul Winter Consort" "Jah Wobble"
    "Erik Wollo" "Woob" "Yanni" "Yellow Magic Orchestra" "Susumu Yokota" "Zero 7" "Zoviet France" "Wardruna")

while :; do
    RANDOM=$$$(date +%s)
    ARTIST=${ARTISTS[$RANDOM % ${#ARTISTS[@]}]}

    echo -e "\033[1;30mAmbient Music: \033[0mPlaying \033[1;32m\"$ARTIST\"\033[0m."
     
    ARTIST=${ARTIST// /%20}
    ARTIST=${ARTIST//&/%26}

    TAG="#music"
    URL="https://www.youtube.com/results?search_query="
    mpv "$URL$ARTIST$TAG" --really-quiet --force-window=immediate --keep-open &
    disown

    read -n1 -r -p $'Press \'x\' to disown OR any key to pick new artist...\n' key
    if [ "$key" = 'x' ]; then
        exit 0
    else
        kill $!
    fi
done

exit 0

