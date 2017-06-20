class BirdsResponse
  def self.all(birds)
    birds.map{|b| details(b)}
  end

  def self.details(bird)
    {
      id: bird.id.to_s,
      name: bird.name,
      family: bird.family,
      continents: bird.continents,
      added: bird.added.strftime('%Y-%m-%d')
    }
  end
end