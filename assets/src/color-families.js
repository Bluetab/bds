/*
  BLUETAB COLOR FAMILIES
  ------------------------------------------------------------------
  9-step tint/shade scales. Level 50 is the Bluetab master color;
  10–40 mix it with white (80, 60, 40, 20 %) and 60–90 mix it with
  black (20, 40, 60, 80 %). Each percentage is applied to the master,
  not accumulated.

  Each step: [hex, CMYK]. Only the master keeps a Pantone reference;
  the CMYK of derived steps is an indicative RGB conversion, so print
  artwork must be converted with the target ICC profile.
  Source of truth for palette tokens (tokens.css), the Colors catalog
  page and `Bds.Catalog.color_families/0` (via priv/catalog.json).
*/

const RAW_FAMILIES = [
  {
    id: "bluetab-blue",
    name: "Bluetab Blue",
    pantone: "PANTONE 2746 C",
    steps: [
      ["D3D3E9", "9 / 9 / 0 / 9"],
      ["A6A7D3", "21 / 21 / 0 / 17"],
      ["7A7CBE", "36 / 35 / 0 / 25"],
      ["4D50A8", "54 / 52 / 0 / 34"],
      ["212492", "100 / 88 / 0 / 10"],
      ["1A1D75", "78 / 75 / 0 / 54"],
      ["141658", "77 / 75 / 0 / 65"],
      ["0D0E3A", "78 / 76 / 0 / 77"],
      ["07071D", "76 / 76 / 0 / 89"],
    ],
  },
  {
    id: "bluetab-orange",
    name: "Bluetab Orange",
    pantone: "PANTONE 166 C",
    steps: [
      ["F9DCCD", "0 / 12 / 18 / 2"],
      ["F3BA9B", "0 / 23 / 36 / 5"],
      ["EC976A", "0 / 36 / 55 / 7"],
      ["E67538", "0 / 49 / 76 / 10"],
      ["E05206", "0 / 74 / 100 / 0"],
      ["B34205", "0 / 63 / 97 / 30"],
      ["863104", "0 / 63 / 97 / 47"],
      ["5A2102", "0 / 63 / 98 / 65"],
      ["2D1001", "0 / 64 / 98 / 82"],
    ],
  },
  {
    id: "purple",
    name: "Purple",
    pantone: "PANTONE 268 C",
    steps: [
      ["DDD4E3", "3 / 7 / 0 / 11"],
      ["BBA8C8", "7 / 16 / 0 / 22"],
      ["987DAC", "12 / 27 / 0 / 33"],
      ["765191", "19 / 44 / 0 / 43"],
      ["542675", "83 / 100 / 15 / 5"],
      ["431E5E", "29 / 68 / 0 / 63"],
      ["321746", "29 / 67 / 0 / 73"],
      ["220F2F", "28 / 68 / 0 / 82"],
      ["110817", "26 / 65 / 0 / 91"],
    ],
  },
  {
    id: "deep-purple",
    name: "Deep Purple",
    pantone: "PANTONE 7680 C",
    steps: [
      ["D6D4E5", "7 / 7 / 0 / 10"],
      ["ADA9CB", "15 / 17 / 0 / 20"],
      ["837DB2", "26 / 30 / 0 / 30"],
      ["5A5298", "41 / 46 / 0 / 40"],
      ["31277E", "99 / 98 / 13 / 2"],
      ["271F65", "61 / 69 / 0 / 60"],
      ["1D174C", "62 / 70 / 0 / 70"],
      ["141032", "60 / 68 / 0 / 80"],
      ["0A0819", "60 / 68 / 0 / 90"],
    ],
  },
  {
    id: "royal-blue",
    name: "Royal Blue",
    pantone: "PANTONE 2726 C",
    steps: [
      ["D6D7F8", "14 / 13 / 0 / 3"],
      ["ADB0F0", "28 / 27 / 0 / 6"],
      ["8588E9", "43 / 42 / 0 / 9"],
      ["5C61E1", "59 / 57 / 0 / 12"],
      ["3339DA", "89 / 75 / 0 / 0"],
      ["292EAE", "76 / 74 / 0 / 32"],
      ["1F2283", "76 / 74 / 0 / 49"],
      ["141757", "77 / 74 / 0 / 66"],
      ["0A0B2C", "77 / 75 / 0 / 83"],
    ],
  },
  {
    id: "soft-blue",
    name: "Soft Blue",
    pantone: "PANTONE 2725 C",
    steps: [
      ["DDDEEC", "6 / 6 / 0 / 7"],
      ["BCBDD9", "13 / 13 / 0 / 15"],
      ["9A9BC6", "22 / 22 / 0 / 22"],
      ["797AB3", "32 / 32 / 0 / 30"],
      ["5759A0", "77 / 68 / 3 / 0"],
      ["464780", "45 / 45 / 0 / 50"],
      ["343560", "46 / 45 / 0 / 62"],
      ["232440", "45 / 44 / 0 / 75"],
      ["111220", "47 / 44 / 0 / 87"],
    ],
  },
  {
    id: "periwinkle",
    name: "Periwinkle",
    pantone: "PANTONE 272 C",
    steps: [
      ["E4E4F8", "8 / 8 / 0 / 3"],
      ["C8C9F0", "17 / 16 / 0 / 6"],
      ["ADAFE9", "26 / 25 / 0 / 9"],
      ["9194E1", "36 / 34 / 0 / 12"],
      ["7679DA", "64 / 55 / 0 / 0"],
      ["5E61AE", "46 / 44 / 0 / 32"],
      ["474983", "46 / 44 / 0 / 49"],
      ["2F3057", "46 / 45 / 0 / 66"],
      ["18182C", "45 / 45 / 0 / 83"],
    ],
  },
  {
    id: "electric-blue",
    name: "Electric Blue",
    pantone: "PANTONE 2727 C",
    steps: [
      ["CCE0FF", "20 / 12 / 0 / 0"],
      ["99C1FF", "40 / 24 / 0 / 0"],
      ["66A3FF", "60 / 36 / 0 / 0"],
      ["3384FF", "80 / 48 / 0 / 0"],
      ["0065FF", "85 / 61 / 0 / 0"],
      ["0051CC", "100 / 60 / 0 / 20"],
      ["003D99", "100 / 60 / 0 / 40"],
      ["002866", "100 / 61 / 0 / 60"],
      ["001433", "100 / 61 / 0 / 80"],
    ],
  },
  {
    id: "navy",
    name: "Navy",
    pantone: "PANTONE 273 C",
    steps: [
      ["D0D1DF", "7 / 6 / 0 / 13"],
      ["A2A3BF", "15 / 15 / 0 / 25"],
      ["73749E", "27 / 27 / 0 / 38"],
      ["45467E", "45 / 44 / 0 / 51"],
      ["16185E", "100 / 95 / 35 / 26"],
      ["12134B", "76 / 75 / 0 / 71"],
      ["0D0E38", "77 / 75 / 0 / 78"],
      ["090A26", "76 / 74 / 0 / 85"],
      ["040513", "79 / 74 / 0 / 93"],
    ],
  },
  {
    id: "red",
    name: "Red",
    pantone: "PANTONE 186 C",
    steps: [
      ["F3D1D7", "0 / 14 / 12 / 5"],
      ["E7A3AF", "0 / 29 / 24 / 9"],
      ["DA7687", "0 / 46 / 38 / 15"],
      ["CE485F", "0 / 65 / 54 / 19"],
      ["C21A37", "16 / 99 / 72 / 6"],
      ["9B152C", "0 / 86 / 72 / 39"],
      ["741021", "0 / 86 / 72 / 55"],
      ["4E0A16", "0 / 87 / 72 / 69"],
      ["27050B", "0 / 87 / 72 / 85"],
    ],
  },
  {
    id: "warm-red",
    name: "Warm Red",
    pantone: "PANTONE 179 C",
    steps: [
      ["FAD8D4", "0 / 14 / 15 / 2"],
      ["F5B1A9", "0 / 28 / 31 / 4"],
      ["F1897E", "0 / 43 / 48 / 5"],
      ["EC6253", "0 / 58 / 65 / 7"],
      ["E73B28", "2 / 87 / 88 / 0"],
      ["B92F20", "0 / 75 / 83 / 27"],
      ["8B2318", "0 / 75 / 83 / 45"],
      ["5C1810", "0 / 74 / 83 / 64"],
      ["2E0C08", "0 / 74 / 83 / 82"],
    ],
  },
  {
    id: "amber",
    name: "Amber",
    pantone: "PANTONE 144 C",
    steps: [
      ["FAE8CD", "0 / 7 / 18 / 2"],
      ["F5D19C", "0 / 15 / 36 / 4"],
      ["F1BA6A", "0 / 23 / 56 / 5"],
      ["ECA339", "0 / 31 / 76 / 7"],
      ["E78C07", "7 / 51 / 99 / 0"],
      ["B97006", "0 / 39 / 97 / 27"],
      ["8B5404", "0 / 40 / 97 / 45"],
      ["5C3803", "0 / 39 / 97 / 64"],
      ["2E1C01", "0 / 39 / 98 / 82"],
    ],
  },
  {
    id: "teal",
    name: "Teal",
    pantone: "PANTONE 7717 C",
    steps: [
      ["CCE8E6", "12 / 0 / 1 / 9"],
      ["99D1CC", "27 / 0 / 2 / 18"],
      ["66B9B3", "45 / 0 / 3 / 27"],
      ["33A299", "69 / 0 / 6 / 36"],
      ["008B80", "82 / 22 / 53 / 6"],
      ["006F66", "100 / 0 / 8 / 56"],
      ["00534D", "100 / 0 / 7 / 67"],
      ["003833", "100 / 0 / 9 / 78"],
      ["001C1A", "100 / 0 / 7 / 89"],
    ],
  },
  {
    id: "neutral-black",
    name: "Neutral Black",
    pantone: "Neutral Black C",
    steps: [
      ["D2D3D5", "1 / 1 / 0 / 16"],
      ["A5A7AB", "4 / 2 / 0 / 33"],
      ["797A81", "6 / 5 / 0 / 49"],
      ["4C4E57", "13 / 10 / 0 / 66"],
      ["1F222D", "87 / 76 / 53 / 68"],
      ["191B24", "31 / 25 / 0 / 86"],
      ["13141B", "30 / 26 / 0 / 89"],
      ["0C0E12", "33 / 22 / 0 / 93"],
      ["060709", "33 / 22 / 0 / 96"],
    ],
  },
];

export const MASTER_LEVEL = 50;

const LABEL_ON_LIGHT = "#1f222d";
const LABEL_ON_DARK = "#ffffff";

const channels = (hex) => [0, 2, 4].map((offset) => parseInt(hex.slice(offset, offset + 2), 16));

const hexToRgb = (hex) => channels(hex).join(" / ");

const luminance = (hex) => {
  const [r, g, b] = channels(hex.replace("#", "")).map((channel) => {
    const value = channel / 255;
    return value <= 0.03928 ? value / 12.92 : ((value + 0.055) / 1.055) ** 2.4;
  });
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
};

const contrast = (a, b) => {
  const [light, dark] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (light + 0.05) / (dark + 0.05);
};

// Label tone = whichever of the two label colors reads better on the swatch.
const toneFor = (hex) =>
  contrast(hex, LABEL_ON_DARK) >= contrast(hex, LABEL_ON_LIGHT) ? "light" : "dark";

// Levels 10–40 → white 80/60/40/20 %; 50 → master; 60–90 → black 20/40/60/80 %.
const mixFor = (level) => {
  const position = level / 10;
  if (level === MASTER_LEVEL) return { mix: "master", percent: null };
  if (level < MASTER_LEVEL) return { mix: "white", percent: 100 - position * 20 };
  return { mix: "black", percent: (position - MASTER_LEVEL / 10) * 20 };
};

export const COLOR_FAMILIES = RAW_FAMILIES.map((family) => ({
  id: family.id,
  name: family.name,
  pantone: family.pantone,
  master: `#${family.steps[MASTER_LEVEL / 10 - 1][0]}`,
  steps: family.steps.map(([hex, cmyk], index) => {
    const level = (index + 1) * 10;
    const { mix, percent } = mixFor(level);
    return {
      level,
      token: `--bt-palette-${family.id}-${level}`,
      hex: `#${hex}`,
      rgb: hexToRgb(hex),
      cmyk,
      spot: level === MASTER_LEVEL ? family.pantone : null,
      tone: toneFor(hex),
      master: level === MASTER_LEVEL,
      mix,
      mix_percent: percent,
    };
  }),
}));

export const paletteTokensCss = () =>
  COLOR_FAMILIES.map(
    (family) =>
      `  /* ${family.name} · ${family.pantone} */\n` +
      family.steps.map((step) => `  ${step.token}: ${step.hex.toLowerCase()};`).join("\n"),
  ).join("\n\n");

// A no-break space keeps "80 %" together, so the % never wraps onto its own line.
const mixLabel = (step) =>
  step.master ? "Master" : `${step.mix === "white" ? "White" : "Black"} ${step.mix_percent}\u00A0%`;

const stepHtml = (step, family) => {
  const classes = [
    "bt-color-scale__step",
    `bt-color-scale__step--on-${step.tone}`,
    step.master && "bt-color-scale__step--master",
  ]
    .filter(Boolean)
    .join(" ");
  const label = `Copy ${step.hex} (${family.name}, ${mixLabel(step)})`;
  const chip = step.master ? `<span class="bt-color-scale__chip">Master</span>` : "";
  const plain = (values) => values.replaceAll(" / ", " ");
  const pantone = step.spot ? `\n          <div><dt>Pantone</dt><dd>${step.spot.replace(/^PANTONE /, "")}</dd></div>` : "";

  return `    <div class="${classes}" role="listitem" style="--swatch: var(${step.token})">
      <button class="bt-color-scale__bar" type="button" data-copy-hex="${step.hex}" aria-label="${label}" title="Copy ${step.hex}">${chip}</button>
      <span class="bt-color-scale__info">
        <span class="bt-color-scale__mix">${mixLabel(step)}</span>
        <span class="bt-color-scale__hex">${step.hex}</span>
        <dl class="bt-color-scale__data">
          <div><dt>RGB</dt><dd class="bt-color-scale__values">${plain(step.rgb)}</dd></div>
          <div><dt>CMYK</dt><dd class="bt-color-scale__values">${plain(step.cmyk)}</dd></div>${pantone}
        </dl>
      </span>
    </div>`;
};

export const colorScaleHtml = (family) =>
  `<div class="bt-color-scale-wrap">
  <div class="bt-color-scale" role="list" aria-label="${family.name}">
${family.steps.map((step) => stepHtml(step, family)).join("\n")}
  </div>
</div>`;
