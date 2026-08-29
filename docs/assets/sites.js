/* ============================================================================
   COSE — shared site registry (the "site map" content + future hub source).
   Edit THIS one file to add/rename a project; every page that ships a copy
   (or loads the hosted copy) gets the updated cross-site nav.

   Groups + titles follow Richard's authoritative list (2026-07-24).
   `id` must match the repo slug (last path segment of the github.io URL) so a
   page can mark "you are here" via <body data-site-id="…">.
   `live:false` renders as "page pending" and is skipped by the hub.
   ========================================================================== */
window.BARKER_SITES = {
  brand: { name:"COSE", url:"https://cosecloud.com/", logo:"assets/cose-logo.png" },
  hub: "https://dr-richard-barker.github.io/CoSE_Cloud/Hub/",
  // Named subsets. A themed sub-hub links with ?cose_scope=NAME to limit the
  // in-page project rail (and framework sidebars) to just these projects.
  // `sections` is the single source of truth: the matching sub-hub page renders
  // its card grid from these, and each scope's flat `ids` list (used by the rail
  // filter) is derived from the sections below — add a project in ONE place.
  scopes: {
    astrobotany: { label: "AstroBotany", sections: [
      { name:"Analyses", blurb:"Spaceflight & radiation transcriptomics / multi-omics studies.",
        ids:["arabidopsis-drem-osdr","Plant_response_to_radiation","Airflow_omics","arabidopsis-spaceflight-omics","APEX05_results_and_code",
             "B_rappa_LLGCSS","osdr-plant-microbiome","Circadian_decoder","VEGGIE_Tom_Red_Blue_Leaves_and_adv_roots"] },
      { name:"Crops", blurb:"Crop plants grown and studied in spaceflight conditions.",
        ids:["veg05-integrated-omics","TICTOC","fungal-bgc-atlas"] },
      { name:"Tools", blurb:"Interactive decoders, simulators & reusable analysis pipelines.",
        ids:["Tropism_autodecoder_2026","germinator-ai","Seed_sowing_simulator","Physics-simulator-for-statolith-modelling-","smallRNAseq-DREAM",
             "astroroot","AstroBotany_calibration_image_sharing_and_analysis","Anthocyanin-Image-analysis","AstroRegolith","AstroMycology","Lunar_Red_Alert","biosim-nextgen","Redox_decoder","cose-arcade","lunar-arcade"] },
      { name:"Education", blurb:"Courses & classroom-facing astrobotany outreach.",
        ids:["AIRI","madwest-astrobotany"] }
    ]},
    deepspaceag: { label: "Deep Space Agriculture", sections: [
      { name:"Plant systems & crops", blurb:"Growth-chamber gas transport, radiation, germination and crop physiology off Earth.",
        ids:["LunarLeaf-CFD","Airflow_omics","Aero-leaf-CFD-analysis-adapted-from-blender-ish","spaceflight-plant-hardware-cfd","Plant_response_to_radiation","B_rappa_LLGCSS","PhysioSpace_stress_decoding_VEG05","germinator-ai","Seed_sowing_simulator","lunar-magnetic-biology","AstroRegolith","AstroMycology","microgreen-chamber-cfd","fungal-bgc-atlas","biosim-nextgen","VEGGIE_Tom_Red_Blue_Leaves_and_adv_roots"] },
      { name:"Planetary environment", blurb:"Magnetic fields, radiation, and environmental conditions on the Moon and Mars.",
        ids:["mars-magnetic-biology","clpds-planetary-visualization","earth-magnetosphere-4d-viz"] },
      { name:"Stress & biomarker decoders", blurb:"Machine-learning decoders of spaceflight and radiation stress signatures.",
        ids:["deepspace-seed-stress-decoder","astronaut-oncogene-biomarkers","Circadian_decoder","Redox_decoder"] },
      { name:"Astronaut health", blurb:"Searchable evidence and trend analytics for crew health.",
        ids:["Muscle-Atrophy-Multi-Omics-OSDR","Astronaut_flavenoids_and_biomarkers","Astronaut_trends","Astronaut_brain_food"] },
      { name:"Data & education", blurb:"Open OSDR data notebooks and training resources.",
        ids:["OSDR_jupyter_book.io"] }
    ]},
    astronauthealth: { label: "Astronaut Health", sections: [
      { name: "Physiology & Countermeasures", blurb: "Astronaut muscle atrophy, oncogene biomarkers, and nutritional countermeasures.",
        ids: ["Muscle-Atrophy-Multi-Omics-OSDR", "Astronaut_flavenoids_and_biomarkers", "Astronaut_brain_food", "astronaut-oncogene-biomarkers"] },
      { name: "Analytics & Dashboards", blurb: "Interactive dashboards and evidence analytics for crew health.",
        ids: ["Astronaut_trends"] }
    ]}
  },
  groups: [
    {
      name: "Featured",
      items: [
        { id:"LunarLeaf-CFD", emoji:"🍃", title:"Lunar LEAF — Photorespiration",
          desc:"CFD model of photorespiration in a lunar growth chamber",
          url:"https://dr-richard-barker.github.io/LunarLeaf-CFD/" },
        { id:"deepspace-seed-stress-decoder", emoji:"🌰", title:"DeepSpace Seed Stress Decoder",
          desc:"Decoding seed stress signatures for deep-space conditions",
          url:"https://dr-richard-barker.github.io/deepspace-seed-stress-decoder/" },
        { id:"arabidopsis-drem-osdr", emoji:"🧬", title:"DREM cell-type prior",
          desc:"Cell-type-weighted DREM over OSDR Arabidopsis pseudo-time-series",
          url:"https://dr-richard-barker.github.io/arabidopsis-drem-osdr/" },
        { id:"Plant_response_to_radiation", emoji:"☢️", title:"OSDR Radiation Review",
          desc:"Radiation review & kinetic pattern-recognition across NASA OSDR",
          url:"https://dr-richard-barker.github.io/Plant_response_to_radiation/" },
        { id:"Astronaut_flavenoids_and_biomarkers", emoji:"🧬", title:"Astronaut Health Summary",
          desc:"Spaceflight oncogenic biomarkers & their reversal by food-derived flavonoids",
          url:"https://dr-richard-barker.github.io/Astronaut_flavenoids_and_biomarkers/" },
        { id:"Astronaut_trends", emoji:"📊", title:"Astronaut Trends Dashboard",
          desc:"Interactive dashboard of astronaut health trends",
          url:"https://dr-richard-barker.github.io/Astronaut_trends/" },
        { id:"astronaut-oncogene-biomarkers", emoji:"🎗️", title:"Astronaut Oncogene Biomarkers",
          desc:"Cross-tissue transcriptomics: how spaceflight & radiation converge on shared oncogenic programs",
          url:"https://dr-richard-barker.github.io/astronaut-oncogene-biomarkers/" },
        { id:"Astronaut_brain_food", emoji:"🥗", title:"Astronaut Opposite Forcing",
          desc:"Consensus spaceflight transcriptomic signatures reversed via LINCS L1000, translated into vegan nutritional countermeasures",
          url:"https://dr-richard-barker.github.io/Astronaut_brain_food/" },
        { id:"Muscle-Atrophy-Multi-Omics-OSDR", emoji:"💪", title:"Muscle Atrophy Countermeasures",
          desc:"Cross-species meta-analysis of spaceflight muscle atrophy transcriptomics & translation to plant-based countermeasures",
          url:"https://dr-richard-barker.github.io/Muscle-Atrophy-Multi-Omics-OSDR/" },
      ]
    },
    {
      name: "Spaceflight Omics & Transcriptomics",
      items: [
        { id:"Circadian_decoder", emoji:"⏰", title:"Circadian Decoder",
          desc:"ChronoGauge deep learning meta-analysis of spaceflight circadian clock phase disruption",
          url:"https://dr-richard-barker.github.io/Circadian_decoder/" },
        { id:"Tropism_autodecoder_2026", emoji:"🧭", title:"Tropism Autodecoder 2026",
          desc:"Auto-decoder atlas of plant tropism responses",
          url:"https://dr-richard-barker.github.io/Tropism_autodecoder_2026/" },
        { id:"arabidopsis-spaceflight-omics", emoji:"🌿", title:"Arabidopsis Spaceflight Omics",
          desc:"LASSO biomarkers, single-cell atlas integration & Ca²⁺ cell–cell signalling across NASA OSDR",
          url:"https://dr-richard-barker.github.io/arabidopsis-spaceflight-omics/" },
        { id:"B_rappa_LLGCSS", emoji:"🌸", title:"B. rapa — Floral Scent × Radiation",
          desc:"Does galactic cosmic radiation alter floral scent? WIP transcriptomics in Brassica rapa",
          url:"https://dr-richard-barker.github.io/B_rappa_LLGCSS/" },
        { id:"APEX05_results_and_code", emoji:"🪴", title:"APEX-05 Clean-Up & Analysis",
          desc:"APEX-05 results and reproducible analysis code",
          url:"https://dr-richard-barker.github.io/APEX05_results_and_code/" },
        { id:"TICTOC", emoji:"🧵", title:"TICTOC Project Clean-Up",
          desc:"TICTOC project data clean-up and documentation",
          url:"https://dr-richard-barker.github.io/TICTOC/" },
        { id:"smallRNAseq-DREAM", emoji:"🧫", title:"MicroRNA Analysis Pipeline",
          desc:"Cross-species small-RNA-seq (miRNA) pipeline & OSDR mining test",
          url:"https://dr-richard-barker.github.io/smallRNAseq-DREAM/" },
        { id:"Airflow_omics", emoji:"🌬️", title:"Airflow Omics Model",
          desc:"CFD-guided multi-omics meta-analysis of Arabidopsis spaceflight adaptation & gas exchange",
          url:"https://dr-richard-barker.github.io/Airflow_omics/" },
        { id:"spaceflight-plant-hardware-cfd", emoji:"🛸", title:"Spaceflight Plant Hardware CFD",
          desc:"OpenFOAM 3D CFD of boundary-layer scaling across five spaceflight growth chambers at four gravity regimes",
          url:"https://dr-richard-barker.github.io/spaceflight-plant-hardware-cfd/" },
        { id:"mars-magnetic-biology", emoji:"🔴", title:"Mars Magnetic Biology",
          desc:"Crustal magnetic field heterogeneity & biological implications at candidate Mars landing sites",
          url:"https://dr-richard-barker.github.io/mars-magnetic-biology/" },
      ]
    },
    {
      name: "Microbiome & Multi-Omics Reviews",
      items: [
        { id:"osdr-plant-microbiome", emoji:"🦠", title:"OSDR Plant Microbiome Review",
          desc:"Plant microbiome review & manuscript",
          url:"https://dr-richard-barker.github.io/osdr-plant-microbiome/" },
        { id:"veg05-integrated-omics", emoji:"🍅", title:"VEG-05 Integrated-Omics",
          desc:"Multi-omics of ISS dwarf tomato (VEG-05): red- vs blue-rich lighting vs KSC controls",
          url:"https://dr-richard-barker.github.io/veg05-integrated-omics/" },
        { id:"PhysioSpace_stress_decoding_VEG05", emoji:"🧠", title:"PhysioSpace VEG-05",
          desc:"Light quality × spaceflight stress decoding with cell-type asymmetry in ISS tomato (OSD-767)",
          url:"https://dr-richard-barker.github.io/PhysioSpace_stress_decoding_VEG05/" },
      ]
    },
    {
      name: "Interactive Notebooks, Web Tools & Pipelines",
      items: [
        { id:"Anthocyanin-Image-analysis", emoji:"🍁", title:"Anthocyanin Image Analysis Tool",
          desc:"Browser tool for anthocyanin image analysis",
          url:"https://dr-richard-barker.github.io/Anthocyanin-Image-analysis/" },
        { id:"AstroBotany_calibration_image_sharing_and_analysis", emoji:"📐", title:"AstroBotany Calibration Image DB",
          desc:"Epicollect5-sourced specimen photos with in-browser ArUco colour/scale calibration — hands off to AstroRoot & Leaf Pigment tools",
          url:"https://dr-richard-barker.github.io/AstroBotany_calibration_image_sharing_and_analysis/" },
        { id:"astroroot", emoji:"🛰️", title:"AstroRoot",
          desc:"In-browser root image analysis for the classroom",
          url:"https://dr-richard-barker.github.io/astroroot/" },
        { id:"virtual-root", emoji:"🌱", title:"Virtual Root",
          desc:"Interactive auxin-transport root model",
          url:"https://dr-richard-barker.github.io/virtual-root/" },
        { id:"germinator-ai", emoji:"🌾", title:"Germinator AI",
          desc:"Browser-based AI-powered seed germination analysis — upload time-lapse images to measure germination rate, T₅₀, uniformity and more",
          url:"https://dr-richard-barker.github.io/germinator-ai/" },
        { id:"Seed_sowing_simulator", emoji:"🫘", title:"Seed Germination Simulator",
          desc:"Sow seeds in a virtual Petri dish — watch gravitropism, phototropism & lateral branching in-silico. New v2: branching calibrated against real root-image (RSML) data",
          url:"https://dr-richard-barker.github.io/Seed_sowing_simulator/" },
        { id:"Physics-simulator-for-statolith-modelling-", emoji:"⚖️", title:"Statolith Physics Simulator",
          desc:"Sandbox for statolith sedimentation — tune gravity, rotation & stickiness across container shapes",
          url:"https://dr-richard-barker.github.io/Physics-simulator-for-statolith-modelling-/" },
        { id:"Aero-leaf-CFD-analysis-adapted-from-blender-ish", emoji:"🌬️", title:"AeroLeaf CFD",
          desc:"Browser CFD wizard: upload a 3D leaf model and analyse airflow around it",
          url:"https://dr-richard-barker.github.io/Aero-leaf-CFD-analysis-adapted-from-blender-ish/" },
        { id:"SBGN-Pathway-viewer", emoji:"🗺️", title:"SBGN / KEGG Pathway Viewer",
          desc:"Overlay RNA-seq & omics onto KEGG / Reactome pathway maps in the browser — no API key",
          url:"https://dr-richard-barker.github.io/SBGN-Pathway-viewer/" },
        { id:"eFP-report-generator", emoji:"📋", title:"Gene eFP Report Generator",
          desc:"Keyless: illustrative GO + tissue schematics per gene, with links to real BAR ePlant / TAIR data",
          url:"https://dr-richard-barker.github.io/eFP-report-generator/" },
        { id:"infogenius-standalone", emoji:"💡", title:"InfoGenius — Knowledge Engine",
          desc:"Keyless browser tool that turns a topic into a researched infographic",
          url:"https://dr-richard-barker.github.io/infogenius-standalone/" },
        { id:"madwest-astrobotany", emoji:"🚀", title:"MadWest Astrobotany",
          desc:"MadWest astrobotany outreach & resources",
          url:"https://dr-richard-barker.github.io/madwest-astrobotany/" },
        { id:"lunar-magnetic-biology", emoji:"🧲", title:"Lunar Magnetic Biology",
          desc:"Interactive 3D globe visualizing lunar magnetic anomalies and their biological effects",
          url:"https://dr-richard-barker.github.io/lunar-magnetic-biology/" },
        { id:"clpds-planetary-visualization", emoji:"🪐", title:"Planetary Exploration Suite (CLPDS)",
          desc:"Interactive data visualization suite for China's lunar (Chang'e) and Martian (Tianwen) exploration data",
          url:"https://dr-richard-barker.github.io/clpds-planetary-visualization/" },
        { id:"AstroRegolith", emoji:"🌱", title:"AstroRegolith Reanalysis",
          desc:"NASA dataset reanalysis & open web database for plant growth in lunar, Martian, and asteroid regolith",
          url:"https://dr-richard-barker.github.io/AstroRegolith/", thumb_ext:"gif" },
        { id:"AstroMycology", emoji:"🍄", title:"AstroMycology Scan Database",
          desc:"Vite/React image + 3D scan library with an in-browser mesh viewer and volume/surface analysis",
          url:"https://dr-richard-barker.github.io/AstroMycology/", thumb_ext:"gif" },
        { id:"microgreen-chamber-cfd", emoji:"🌬️", title:"Microgreen CFD Model",
          desc:"OpenFOAM 3D computational fluid dynamics (CFD) internal airflow analysis of a growth chamber",
          url:"https://dr-richard-barker.github.io/microgreen-chamber-cfd/", thumb_ext:"gif" },
        { id:"earth-magnetosphere-4d-viz", emoji:"🛡️", title:"4D Geospace Explorer",
          desc:"Dynamic 4D visualization of Earth's magnetosphere, field lines, and magnetosheath currents",
          url:"https://dr-richard-barker.github.io/earth-magnetosphere-4d-viz/", thumb_ext:"gif" },
        { id:"Redox_decoder", emoji:"🧬", title:"ROS Autoencoder (Redox)",
          desc:"Conditional Variational Autoencoder (CVAE) framework resolving plant reactive oxygen species (ROS) kinetic signatures",
          url:"https://dr-richard-barker.github.io/Redox_decoder/", thumb_ext:"gif" },
        { id:"VEGGIE_Tom_Red_Blue_Leaves_and_adv_roots", emoji:"🍅", title:"VEGGIE Red/Blue Tomato",
          desc:"Spaceflight dwarf tomato (cv. Red Robin) OSD-767 transcriptomic profile under red/blue light covariates",
          url:"https://dr-richard-barker.github.io/VEGGIE_Tom_Red_Blue_Leaves_and_adv_roots/", thumb_ext:"gif" },
      ]
    },
    {
      name: "Games & 3D Simulations",
      items: [
        { id:"Settlers_of_the_Moon_or_Mars", emoji:"🪐", title:"Settlers of the Moon or Mars",
          desc:"Space-biology education game: browser colony sim, AI role-play & a 3D-printed board",
          url:"https://dr-richard-barker.github.io/Settlers_of_the_Moon_or_Mars/" },
        { id:"Lunar-and-Martian-frontier-game-prototype", emoji:"🕹️", title:"Lunar & Martian Frontier",
          desc:"Browser colony-building game prototype set on the Moon and Mars",
          url:"https://dr-richard-barker.github.io/Lunar-and-Martian-frontier-game-prototype/" },
        { id:"Lunar_Red_Alert", emoji:"🚀", title:"Lunar Red Alert",
          desc:"Libre Blazor WebAssembly real-time strategy (RTS) space game engine clone",
          url:"https://dr-richard-barker.github.io/Lunar_Red_Alert/", thumb_ext:"gif" },
        { id:"biosim-nextgen", emoji:"🚀", title:"BioSim Next-Gen",
          desc:"4K HLS Rocket Habitat Simulation: dynamic Three.js canvas, agent mind, and environmental controls",
          url:"https://dr-richard-barker.github.io/biosim-nextgen/", thumb_ext:"gif" },
        { id:"cose-arcade", emoji:"🕹️", title:"CoSE Space Arcade",
          desc:"Central browser-playable retro space simulation games portal and studio experiments",
          url:"https://dr-richard-barker.github.io/cose-arcade/", thumb_ext:"gif" },
        { id:"lunar-arcade", emoji:"🌕", title:"Lunar Arcade Hub",
          desc:"Maxis-tribute space simulation games: Lunar Habitat, Boring Mining Game, and Lunar Farm",
          url:"https://dr-richard-barker.github.io/lunar-arcade/", thumb_ext:"gif" },
      ]
    },
    {
      name: "Documentation & Education Hubs",
      items: [
        { id:"OSDR_jupyter_book.io", emoji:"📓", title:"OSDR Jupyter Book (TOAST10)",
          desc:"OSDR Jupyter Book / TOAST10 interactive notebooks",
          url:"https://dr-richard-barker.github.io/OSDR_jupyter_book.io/" },
        { id:"AIRI", emoji:"🌍", title:"Astrobotany International Research Initiative",
          desc:"AIRI — astrobotany international research initiative",
          url:"https://dr-richard-barker.github.io/AIRI/" },
        { id:"fungal-bgc-atlas", emoji:"🧬", title:"Fungal BGC Atlas",
          desc:"Curated, evidence-linked database of 609 fungal biosynthetic gene cluster (BGC) dossiers",
          url:"https://dr-richard-barker.github.io/fungal-bgc-atlas/", thumb_ext:"gif" },
      ]
    }
  ]
};

// Derive each scope's flat `ids` (consumed by theme.js + cose-booknav.js for the
// rail filter) from its `sections`, so sections stay the single source of truth.
(function(reg){
  if(!reg || !reg.scopes) return;
  Object.keys(reg.scopes).forEach(function(k){
    var sc = reg.scopes[k];
    if(sc && sc.sections && !sc.ids){
      sc.ids = sc.sections.reduce(function(acc, s){ return acc.concat(s.ids || []); }, []);
    }
  });
})(window.BARKER_SITES);
