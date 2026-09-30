/*
  BLUETAB COLOR FAMILIES
  ------------------------------------------------------------------
  10-step tint/shade scales. Level 60 is the Bluetab master color;
  10–50 are derived toward white and 70–100 toward black.

  Each step: [hex, CMYK, text tone ("dark" | "light")].
  Source of truth for palette tokens (tokens.css), the Colors catalog
  page and `Bds.Catalog.color_families/0` (via priv/catalog.json).
*/

const RAW_FAMILIES = [
  {
    id: "bluetab-blue",
    name: "Bluetab Blue",
    pantone: "PANTONE 2746 C",
    steps: [
      ["E9E9F4", "5 / 5 / 0 / 4", "dark"],
      ["C8C8E4", "12 / 12 / 0 / 11", "dark"],
      ["A6A7D3", "21 / 21 / 0 / 17", "dark"],
      ["7A7CBE", "36 / 35 / 0 / 25", "dark"],
      ["4D50A8", "54 / 52 / 0 / 34", "light"],
      ["212492", "100 / 88 / 0 / 10", "light"],
      ["1C1F7C", "77 / 75 / 0 / 51", "light"],
      ["171966", "77 / 75 / 0 / 60", "light"],
      ["101249", "78 / 75 / 0 / 71", "light"],
      ["0A0B2C", "77 / 75 / 0 / 83", "light"],
    ],
  },
  {
    id: "bluetab-orange",
    name: "Bluetab Orange",
    pantone: "PANTONE 166 C",
    steps: [
      ["FCEEE6", "0 / 6 / 9 / 1", "dark"],
      ["F7D4C1", "0 / 14 / 22 / 3", "dark"],
      ["F3BA9B", "0 / 23 / 36 / 5", "dark"],
      ["EC976A", "0 / 36 / 55 / 7", "dark"],
      ["E67538", "0 / 49 / 76 / 10", "dark"],
      ["E05206", "0 / 74 / 100 / 0", "dark"],
      ["BE4605", "0 / 63 / 97 / 25", "light"],
      ["9D3904", "0 / 64 / 97 / 38", "light"],
      ["702903", "0 / 63 / 97 / 56", "light"],
      ["431902", "0 / 63 / 97 / 74", "light"],
    ],
  },
  {
    id: "purple",
    name: "Purple",
    pantone: "PANTONE 268 C",
    steps: [
      ["EEE9F1", "1 / 3 / 0 / 5", "dark"],
      ["D4C9DC", "4 / 9 / 0 / 14", "dark"],
      ["BBA8C8", "7 / 16 / 0 / 22", "dark"],
      ["987DAC", "12 / 27 / 0 / 33", "dark"],
      ["765191", "19 / 44 / 0 / 43", "light"],
      ["542675", "83 / 100 / 15 / 5", "light"],
      ["472063", "28 / 68 / 0 / 61", "light"],
      ["3B1B52", "28 / 67 / 0 / 68", "light"],
      ["2A133A", "28 / 67 / 0 / 77", "light"],
      ["190B23", "29 / 69 / 0 / 86", "light"],
    ],
  },
  {
    id: "deep-purple",
    name: "Deep Purple",
    pantone: "PANTONE 7680 C",
    steps: [
      ["EAE9F2", "3 / 4 / 0 / 5", "dark"],
      ["CCC9DF", "9 / 10 / 0 / 13", "dark"],
      ["ADA9CB", "15 / 17 / 0 / 20", "dark"],
      ["837DB2", "26 / 30 / 0 / 30", "dark"],
      ["5A5298", "41 / 46 / 0 / 40", "light"],
      ["31277E", "99 / 98 / 13 / 2", "light"],
      ["2A216B", "61 / 69 / 0 / 58", "light"],
      ["221B58", "61 / 69 / 0 / 65", "light"],
      ["18143F", "62 / 68 / 0 / 75", "light"],
      ["0F0C26", "61 / 68 / 0 / 85", "light"],
    ],
  },
  {
    id: "royal-blue",
    name: "Royal Blue",
    pantone: "PANTONE 2726 C",
    steps: [
      ["EBEBFB", "6 / 6 / 0 / 2", "dark"],
      ["CCCEF6", "17 / 16 / 0 / 4", "dark"],
      ["ADB0F0", "28 / 27 / 0 / 6", "dark"],
      ["8588E9", "43 / 42 / 0 / 9", "dark"],
      ["5C61E1", "59 / 57 / 0 / 12", "light"],
      ["3339DA", "89 / 75 / 0 / 0", "light"],
      ["2B30B9", "77 / 74 / 0 / 27", "light"],
      ["242899", "76 / 74 / 0 / 40", "light"],
      ["1A1C6D", "76 / 74 / 0 / 57", "light"],
      ["0F1141", "77 / 74 / 0 / 75", "light"],
    ],
  },
  {
    id: "soft-blue",
    name: "Soft Blue",
    pantone: "PANTONE 2725 C",
    steps: [
      ["EEEEF6", "3 / 3 / 0 / 4", "dark"],
      ["D5D6E7", "8 / 7 / 0 / 9", "dark"],
      ["BCBDD9", "13 / 13 / 0 / 15", "dark"],
      ["9A9BC6", "22 / 22 / 0 / 22", "dark"],
      ["797AB3", "32 / 32 / 0 / 30", "light"],
      ["5759A0", "77 / 68 / 3 / 0", "light"],
      ["4A4C88", "46 / 44 / 0 / 47", "light"],
      ["3D3E70", "46 / 45 / 0 / 56", "light"],
      ["2C2C50", "45 / 45 / 0 / 69", "light"],
      ["1A1B30", "46 / 44 / 0 / 81", "light"],
    ],
  },
  {
    id: "periwinkle",
    name: "Periwinkle",
    pantone: "PANTONE 272 C",
    steps: [
      ["F1F2FB", "4 / 4 / 0 / 2", "dark"],
      ["DDDEF6", "10 / 10 / 0 / 4", "dark"],
      ["C8C9F0", "17 / 16 / 0 / 6", "dark"],
      ["ADAFE9", "26 / 25 / 0 / 9", "dark"],
      ["9194E1", "36 / 34 / 0 / 12", "dark"],
      ["7679DA", "64 / 55 / 0 / 0", "dark"],
      ["6467B9", "46 / 44 / 0 / 27", "light"],
      ["535599", "46 / 44 / 0 / 40", "light"],
      ["3B3C6D", "46 / 45 / 0 / 57", "light"],
      ["232441", "46 / 45 / 0 / 75", "light"],
    ],
  },
  {
    id: "electric-blue",
    name: "Electric Blue",
    pantone: "PANTONE 2727 C",
    steps: [
      ["E6F0FF", "10 / 6 / 0 / 0", "dark"],
      ["BFD8FF", "25 / 15 / 0 / 0", "dark"],
      ["99C1FF", "40 / 24 / 0 / 0", "dark"],
      ["66A3FF", "60 / 36 / 0 / 0", "dark"],
      ["3384FF", "80 / 48 / 0 / 0", "dark"],
      ["0065FF", "85 / 61 / 0 / 0", "light"],
      ["0056D9", "100 / 60 / 0 / 15", "light"],
      ["0047B2", "100 / 60 / 0 / 30", "light"],
      ["003280", "100 / 61 / 0 / 50", "light"],
      ["001E4D", "100 / 61 / 0 / 70", "light"],
    ],
  },
  {
    id: "navy",
    name: "Navy",
    pantone: "PANTONE 273 C",
    steps: [
      ["E8E8EF", "3 / 3 / 0 / 6", "dark"],
      ["C5C5D7", "8 / 8 / 0 / 16", "dark"],
      ["A2A3BF", "15 / 15 / 0 / 25", "dark"],
      ["73749E", "27 / 27 / 0 / 38", "light"],
      ["45467E", "45 / 44 / 0 / 51", "light"],
      ["16185E", "100 / 95 / 35 / 26", "light"],
      ["131450", "76 / 75 / 0 / 69", "light"],
      ["0F1142", "77 / 74 / 0 / 74", "light"],
      ["0B0C2F", "77 / 74 / 0 / 82", "light"],
      ["07071C", "75 / 75 / 0 / 89", "light"],
    ],
  },
  {
    id: "red",
    name: "Red",
    pantone: "PANTONE 186 C",
    steps: [
      ["F9E8EB", "0 / 7 / 6 / 2", "dark"],
      ["F0C6CD", "0 / 17 / 15 / 6", "dark"],
      ["E7A3AF", "0 / 29 / 24 / 9", "dark"],
      ["DA7687", "0 / 46 / 38 / 15", "dark"],
      ["CE485F", "0 / 65 / 54 / 19", "light"],
      ["C21A37", "16 / 99 / 72 / 6", "light"],
      ["A5162F", "0 / 87 / 72 / 35", "light"],
      ["881226", "0 / 87 / 72 / 47", "light"],
      ["610D1C", "0 / 87 / 71 / 62", "light"],
      ["3A0811", "0 / 86 / 71 / 77", "light"],
    ],
  },
  {
    id: "warm-red",
    name: "Warm Red",
    pantone: "PANTONE 179 C",
    steps: [
      ["FDEBEA", "0 / 7 / 8 / 1", "dark"],
      ["F9CEC9", "0 / 17 / 19 / 2", "dark"],
      ["F5B1A9", "0 / 28 / 31 / 4", "dark"],
      ["F1897E", "0 / 43 / 48 / 5", "dark"],
      ["EC6253", "0 / 58 / 65 / 7", "dark"],
      ["E73B28", "2 / 87 / 88 / 0", "light"],
      ["C43222", "0 / 74 / 83 / 23", "light"],
      ["A2291C", "0 / 75 / 83 / 36", "light"],
      ["741E14", "0 / 74 / 83 / 55", "light"],
      ["45120C", "0 / 74 / 83 / 73", "light"],
    ],
  },
  {
    id: "amber",
    name: "Amber",
    pantone: "PANTONE 144 C",
    steps: [
      ["FDF4E6", "0 / 4 / 9 / 1", "dark"],
      ["F9E2C1", "0 / 9 / 22 / 2", "dark"],
      ["F5D19C", "0 / 15 / 36 / 4", "dark"],
      ["F1BA6A", "0 / 23 / 56 / 5", "dark"],
      ["ECA339", "0 / 31 / 76 / 7", "dark"],
      ["E78C07", "7 / 51 / 99 / 0", "dark"],
      ["C47706", "0 / 39 / 97 / 23", "dark"],
      ["A26205", "0 / 40 / 97 / 36", "light"],
      ["744604", "0 / 40 / 97 / 55", "light"],
      ["452A02", "0 / 39 / 97 / 73", "light"],
    ],
  },
  {
    id: "teal",
    name: "Teal",
    pantone: "PANTONE 7717 C",
    steps: [
      ["E6F3F2", "5 / 0 / 0 / 5", "dark"],
      ["BFE2DF", "15 / 0 / 1 / 11", "dark"],
      ["99D1CC", "27 / 0 / 2 / 18", "dark"],
      ["66B9B3", "45 / 0 / 3 / 27", "dark"],
      ["33A299", "69 / 0 / 6 / 36", "dark"],
      ["008B80", "82 / 22 / 53 / 6", "light"],
      ["00766D", "100 / 0 / 8 / 54", "light"],
      ["00615A", "100 / 0 / 7 / 62", "light"],
      ["004640", "100 / 0 / 9 / 73", "light"],
      ["002A26", "100 / 0 / 10 / 84", "light"],
    ],
  },
  {
    id: "neutral-black",
    name: "Neutral Black",
    pantone: "Neutral Black C",
    steps: [
      ["E9E9EA", "0 / 0 / 0 / 8", "dark"],
      ["C7C8CA", "1 / 1 / 0 / 21", "dark"],
      ["A5A7AB", "4 / 2 / 0 / 33", "dark"],
      ["797A81", "6 / 5 / 0 / 49", "light"],
      ["4C4E57", "13 / 10 / 0 / 66", "light"],
      ["1F222D", "87 / 76 / 53 / 68", "light"],
      ["1A1D26", "32 / 24 / 0 / 85", "light"],
      ["16181F", "29 / 23 / 0 / 88", "light"],
      ["101116", "27 / 23 / 0 / 91", "light"],
      ["090A0E", "36 / 29 / 0 / 95", "light"],
    ],
  },
];

export const MASTER_LEVEL = 60;

const hexToRgb = (hex) =>
  [0, 2, 4].map((offset) => parseInt(hex.slice(offset, offset + 2), 16)).join(" / ");

const stepSpot = (level, pantone) => {
  if (level === MASTER_LEVEL) return pantone;
  return level < MASTER_LEVEL ? "Same spot ink / tint" : "No automatic Pantone equivalent";
};

export const COLOR_FAMILIES = RAW_FAMILIES.map((family) => ({
  id: family.id,
  name: family.name,
  pantone: family.pantone,
  master: `#${family.steps[MASTER_LEVEL / 10 - 1][0]}`,
  steps: family.steps.map(([hex, cmyk, tone], index) => {
    const level = (index + 1) * 10;
    return {
      level,
      token: `--bt-palette-${family.id}-${level}`,
      hex: `#${hex}`,
      rgb: hexToRgb(hex),
      cmyk,
      spot: stepSpot(level, family.pantone),
      tone,
      master: level === MASTER_LEVEL,
    };
  }),
}));

export const paletteTokensCss = () =>
  COLOR_FAMILIES.map(
    (family) =>
      `  /* ${family.name} · ${family.pantone} */\n` +
      family.steps.map((step) => `  ${step.token}: ${step.hex.toLowerCase()};`).join("\n"),
  ).join("\n\n");

const stepHtml = (step) => {
  const classes = [
    "bt-color-scale__step",
    `bt-color-scale__step--on-${step.tone}`,
    step.master && "bt-color-scale__step--master",
  ]
    .filter(Boolean)
    .join(" ");

  return `  <div class="${classes}" role="listitem" style="--swatch: var(${step.token})">
    <span class="bt-color-scale__level">${step.level}</span>
    <span class="bt-color-scale__data"><b>${step.hex}</b>RGB ${step.rgb}<br>CMYK ${step.cmyk}<br>${step.spot}</span>
  </div>`;
};

export const colorScaleHtml = (family) =>
  `<div class="bt-color-scale" role="list" aria-label="${family.name}">
${family.steps.map(stepHtml).join("\n")}
</div>`;
