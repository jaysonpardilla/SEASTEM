class ShellReference {
  const ShellReference({
    required this.commonName,
    required this.scientificName,
    required this.habitat,
    required this.edibility,
    required this.safety,
  });

  final String commonName;
  final String scientificName;
  final String habitat;
  final String edibility;
  final String safety;
}

String _normalizeShellLabel(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}

ShellReference? shellReferenceFor(String prediction, String label) {
  final key = _normalizeShellLabel('$prediction $label');
  for (final entry in _shellReferences.entries) {
    if (key.contains(entry.key)) return entry.value;
  }
  return null;
}

const _shellReferences = <String, ShellReference>{
  'bagongon': ShellReference(
    commonName: 'Bagongon',
    scientificName: 'Telescopium telescopium',
    habitat:
        'Mangrove mudflats, brackish water, estuaries and fishpond areas. Usually found on muddy intertidal surfaces, particularly around the upper or shaded portions of mangroves. Common throughout the Philippines.',
    edibility: 'Edible',
    safety:
        'Generally harvested as food in the Philippines. Collect only from clean, non-polluted mangrove and estuarine areas and cook thoroughly.',
  ),
  'conus textile': ShellReference(
    commonName: 'Conus textile',
    scientificName: 'Conus textile - Textile Cone',
    habitat:
        'Shallow tropical marine areas, particularly sand beneath coral and rocks, rocky shores and reef areas. Usually around 0-10 m, although it may occur in related shallow habitats.',
    edibility: 'Not recommended / dangerous',
    safety:
        'Highly venomous. Never handle a live specimen. It can fire a harpoon-like tooth containing venom and potentially cause severe or fatal envenomation.',
  ),
  'mussels': ShellReference(
    commonName: 'Mussels',
    scientificName: 'Perna viridis - Asian Green Mussel',
    habitat:
        'Coastal and estuarine waters, usually shallow water around 0-20 m. They attach to rocks, submerged structures, shells and other hard surfaces. Common and commercially cultured in Cavite, Capiz and Negros Occidental.',
    edibility: 'Edible',
    safety:
        'Eat only mussels from approved or clean harvesting areas. Mussels are filter feeders and can accumulate harmful microorganisms, toxins and pollutants. Cook thoroughly.',
  ),
  'nautilus pompilius': ShellReference(
    commonName: 'Nautilus pompilius',
    scientificName: 'Nautilus pompilius - Chambered Nautilus',
    habitat:
        'Deep reef slopes and continental-shelf or slope areas, often associated with coral-reef drop-offs and deeper areas. Documented movements can range roughly 100-700 m, with some sources reporting habitat to about 750 m.',
    edibility: 'Edible, but limited or local consumption',
    safety:
        'Meat is consumed in some Philippine local markets, but this is a deep-water animal and should not be treated like an ordinary shallow-water shellfish.',
  ),
  'nerita polita': ShellReference(
    commonName: 'Nerita polita',
    scientificName: 'Nerita polita - Polished Nerite',
    habitat:
        'Primarily intertidal rocky and coral areas. Often hides or buries itself in sand during the day and comes out to graze on algae-covered rocks at night. Also occurs around mangroves and has been documented on intertidal shores of Capiz and other Philippine areas.',
    edibility: 'Edible',
    safety:
        'Generally harmless and documented as a food species. As with other wild mollusks, avoid polluted collection sites and cook properly.',
  ),
  'spider conch': ShellReference(
    commonName: 'Spider Conch',
    scientificName: 'Lambis lambis - Common Spider Conch',
    habitat:
        'Shallow tropical marine bottom, generally around 0-24 m. Found around reef and coastal areas and collected by gleaning in the Philippines; documented throughout the Philippines and in Panay.',
    edibility: 'Edible',
    safety:
        'The animal is eaten in the Philippines, including after boiling and preparation as food. Handle the large shell carefully because its projections can be sharp.',
  ),
  'tiger cowrie': ShellReference(
    commonName: 'Tiger Cowrie',
    scientificName: 'Cypraea tigris - Tiger Cowrie',
    habitat:
        'Coral reefs, rocky intertidal areas, sand among rocks or corals, tidal pools and branched corals. Usually from the intertidal to roughly 30 m. Common around Philippine reef environments.',
    edibility: 'Edible',
    safety:
        'Documented as food in the Philippines; the meat may be boiled and eaten. Avoid collecting from contaminated waters and cook thoroughly.',
  ),
  'tuway': ShellReference(
    commonName: 'Tuway',
    scientificName: 'Antigona lacerata - Tuway-matsing',
    habitat:
        'A marine bivalve associated with shallow coastal and soft-bottom environments. In the Philippines it is documented as Tuway-matsing in Batan Bay, Aklan, Panay, and is sold in Capiz markets.',
    edibility: 'Edible',
    safety:
        'A documented edible Philippine mollusk. Because it is a filter-feeding bivalve, harvest should come from safe or approved waters and the meat should be cooked properly.',
  ),
};
