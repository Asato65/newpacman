(() => {
	"use strict";

	const COLS = 16;
	const ROWS = 16;
	const PLAY_ROWS = 13;
	const TILE_COLS_PER_PAGE = COLS * 2;
	const TILE_ROWS = PLAY_ROWS * 2;
	const STORAGE_KEY = "newpacman.mapEditor.v1";
	const HISTORY_LIMIT = 80;
	const BG_PATTERN_TILE_OFFSET = 0x100;
	const TILE_CANVAS_SIZE = 8;
	const TILE_CSS_SIZE = 18;
	const ATTR_COLS = 8;
	const ATTR_ROWS = 7;
	const HIDDEN_BLOCK_ALPHA = 0.52;
	const EDIT_MODE = {
		SELECT: "select",
		DRAW: "draw",
		ERASE: "erase"
	};

	const TYPE = {
		SINGLE: 0,
		PLATFORM: 1,
		BRICK_ROW: 2,
		HARD_ROW: 3,
		COIN_ROW: 4,
		BRICK_COLUMN: 5,
		HARD_COLUMN: 6,
		PIPE: 7,
		HOLE: 0,
		CASTLE: 2,
		STAIRS: 3,
		BIG_PIPE: 4,
		STAIRS_REV: 5
	};

	const SINGLE_BLOCKS = [
		{ id: 0, asm: "SMB_SINGLE_QBLOCK_POWERUP", alias: "BLK_QP", char: "[", glyph: "P", className: "power", label: "パワーアップ" },
		{ id: 1, asm: "SMB_SINGLE_HIDE", alias: "BLK_HIDE", char: "_", glyph: "?", className: "hidden-qblock", label: "隠し" },
		{ id: 2, asm: "SMB_SINGLE_QBLOCK", alias: "BLK_Q", char: "Q", glyph: "?", className: "qblock", label: "ハテナ" },
		{ id: 3, asm: "SMB_SINGLE_COIN", alias: "BLK_COIN", char: "^", glyph: "C", className: "coin", label: "コイン" },
		{ id: 4, asm: "SMB_SINGLE_BRICK", alias: "BLK_BRICK", char: "B", glyph: "B", className: "brick", label: "レンガ" },
		{ id: 5, asm: "SMB_SINGLE_HARD", alias: "BLK_HARD", char: "H", glyph: "H", className: "hard", label: "固いブロック" },
		{ id: 6, asm: "SMB_SINGLE_HARD2", alias: "BLK_HARD2", char: "N", glyph: "N", className: "hard2", label: "固いブロック2" },
		{ id: 7, asm: "SMB_SINGLE_GROUND", alias: "BLK_GROUND", char: "G", glyph: "G", className: "ground", label: "地面" },
		{ id: 8, asm: "SMB_SINGLE_SKY", alias: "BLK_SKY", char: "@", glyph: "", className: "empty-block", label: "空" }
	];

	const BLOCK_BY_CHAR = {
		"@": { glyph: "", className: "sky", label: "空" },
		"B": { glyph: "B", className: "brick", label: "レンガ" },
		"G": { glyph: "G", className: "ground", label: "地面" },
		"H": { glyph: "H", className: "hard", label: "固いブロック" },
		"N": { glyph: "N", className: "hard2", label: "叩き終わったブロック" },
		"Q": { glyph: "?", className: "qblock", label: "ハテナ" },
		"[": { glyph: "P", className: "power", label: "パワーアップ" },
		"^": { glyph: "C", className: "coin", label: "コイン" },
		"_": { glyph: "?", className: "hidden-qblock", label: "隠し" },
		"P": { glyph: "P", className: "pipe", label: "土管" },
		"M": { glyph: "M", className: "marker", label: "マーカー" }
	};

	const METATILES = {
		"@": [0x00, 0x00, 0x00, 0x00],
		"B": [0x94, 0x94, 0x95, 0x95],
		"G": [0x80, 0x81, 0x82, 0x83],
		"H": [0x8c, 0x8d, 0x8e, 0x8f],
		"N": [0x88, 0x89, 0x8a, 0x8b],
		"Q": [0x90, 0x91, 0x92, 0x93],
		"[": [0x90, 0x91, 0x92, 0x93],
		"^": [0x84, 0x85, 0x86, 0x87],
		"_": [0x90, 0x91, 0x92, 0x93],
		"P": [0xa0, 0xa1, 0xa0, 0xa1],
		"pipeTopLeft": [0x98, 0x99, 0x9a, 0x9b],
		"pipeTopRight": [0x9c, 0x9d, 0x9e, 0x9f],
		"pipeLeft": [0xa0, 0xa1, 0xa0, 0xa1],
		"pipeRight": [0x02, 0xa2, 0x02, 0xa2],
		"goalPole": [0xa4, 0xa5, 0xa4, 0xa5],
		"goalBall": [0x00, 0x00, 0xa6, 0xa7],
	};

	const BG_SCENERY_Y_TO_ROW = [0x02, 0x04, 0x0a, 0x0e, 0x12, 0x15, 0x16];

	const BG_MAPS = {
		0: [
			[0x00, 0xa5], [0x11, 0x20], [0x17, 0xc2],
			[0x80, 0xa6], [0x07, 0x00], [0x0f, 0xc0], [0x17, 0x21],
			[0x89, 0x01], [0xd3, 0xc1]
		],
		1: [
			[0x01, 0x21], [0x16, 0xa3], [0x1a, 0xa4], [0x1c, 0xa7], [0x1e, 0xa7],
			[0x80, 0xa7], [0x02, 0xa7], [0x05, 0x20], [0x0a, 0xa4], [0x0e, 0xa3], [0x10, 0xa3], [0x17, 0x00], [0x1d, 0x21],
			[0x8c, 0xa7], [0x0e, 0xa7], [0x10, 0xa3], [0x12, 0xa7], [0x16, 0xa4], [0xdb, 0x00]
		]
	};

	const BG_ATTR_MAPS = {
		0: [
			[0x05, 0x80], [0x06, 0x0a], [0x15, 0xa2], [0x16, 0x0a], [0x26, 0x02],
			[0x41, 0xf0], [0x42, 0x0f], [0x51, 0x30], [0x52, 0x03],
			[0x56, 0xa8], [0x66, 0xaa], [0x76, 0xaa],
			[0x86, 0x0a], [0x05, 0x80], [0x16, 0x02],
			[0x11, 0xcc], [0x21, 0xff],
			[0x36, 0x88], [0x46, 0xaa],
			[0x51, 0xc0], [0x52, 0x0c], [0x61, 0xf0], [0x62, 0x0f], [0x71, 0xf0], [0x72, 0x0f],
			[0xa1, 0xff], [0x31, 0xff],
			[0x46, 0x88], [0x56, 0xaa], [0x66, 0x22]
		],
		1: [
			[0x01, 0xf0], [0x02, 0x0f], [0x11, 0xf0], [0x12, 0x0f],
			[0x55, 0x80], [0x65, 0x88],
			[0x91, 0xf0], [0x12, 0x0f], [0x21, 0x30], [0x22, 0x03],
			[0x25, 0x88], [0x35, 0x80], [0x45, 0x20],
			[0x51, 0xcc], [0x61, 0xff], [0x71, 0xf0], [0x72, 0x0f],
			[0x81, 0xf0], [0x02, 0x0f],
			[0x45, 0x20], [0x55, 0x88],
			[0x61, 0xcc], [0x71, 0xff]
		]
	};
	const BG_OBJECTS = [
		[
			[{ dy: 1, tile: 0xb4 }, { dy: 0, tile: 0xb8 }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 1, tile: 0xb7 }, { dy: 0, tile: 0xbb }]
		],
		[
			[{ dy: 1, tile: 0xb4 }, { dy: 0, tile: 0xb8 }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 1, tile: 0xb7 }, { dy: 0, tile: 0xbb }]
		],
		[
			[{ dy: 1, tile: 0xb4 }, { dy: 0, tile: 0xb8 }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 2, tile: 0xb5 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xb9 }],
			[{ dy: 2, tile: 0xb6 }, { dy: 1, tile: 0xc9 }, { dy: 0, tile: 0xba }],
			[{ dy: 1, tile: 0xb7 }, { dy: 0, tile: 0xbb }]
		],
		[
			[{ dy: 3, tile: 0xc0 }, { dy: 2, tile: 0xc4 }, { dy: 1, tile: 0xc6 }, { dy: 0, tile: 0xc6 }],
			[{ dy: 3, tile: 0xc1 }, { dy: 2, tile: 0xc5 }, { dy: 1, tile: 0xc7 }, { dy: 0, tile: 0xc7 }]
		],
		[
			[{ dy: 5, tile: 0xc0 }, { dy: 4, tile: 0xc2 }, { dy: 3, tile: 0xc2 }, { dy: 2, tile: 0xc4 }, { dy: 1, tile: 0xc6 }, { dy: 0, tile: 0xc6 }],
			[{ dy: 5, tile: 0xc1 }, { dy: 4, tile: 0xc3 }, { dy: 3, tile: 0xc3 }, { dy: 2, tile: 0xc5 }, { dy: 1, tile: 0xc7 }, { dy: 0, tile: 0xc7 }]
		],
		[
			[{ dy: 0, tile: 0xb0 }],
			[{ dy: 1, tile: 0xb0 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 2, tile: 0xb0 }, { dy: 1, tile: 0xc8 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 3, tile: 0xb0 }, { dy: 2, tile: 0xc8 }, { dy: 1, tile: 0xaf }, { dy: 0, tile: 0xc8 }],
			[{ dy: 4, tile: 0xb1 }, { dy: 3, tile: 0xc8 }, { dy: 2, tile: 0xc8 }, { dy: 1, tile: 0xc8 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 4, tile: 0xb2 }, { dy: 3, tile: 0xaf }, { dy: 2, tile: 0xc8 }, { dy: 1, tile: 0xc8 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 3, tile: 0xb3 }, { dy: 2, tile: 0xc8 }, { dy: 1, tile: 0xaf }, { dy: 0, tile: 0xc8 }],
			[{ dy: 2, tile: 0xb3 }, { dy: 1, tile: 0xc8 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 1, tile: 0xb3 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 0, tile: 0xb3 }]
		],
		[
			[{ dy: 0, tile: 0xb0 }],
			[{ dy: 1, tile: 0xb0 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 2, tile: 0xb1 }, { dy: 1, tile: 0xc8 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 2, tile: 0xb2 }, { dy: 1, tile: 0xaf }, { dy: 0, tile: 0xc8 }],
			[{ dy: 1, tile: 0xb3 }, { dy: 0, tile: 0xc8 }],
			[{ dy: 0, tile: 0xb3 }]
		],
		[
			[{ dy: 1, tile: 0xbc }, { dy: 0, tile: 0xbe }],
			[{ dy: 1, tile: 0xbd }, { dy: 0, tile: 0xbf }]
		]
	];

	const DEFAULT_PALETTE_BYTES = {
		palette0: [0x22, 0x36, 0x17, 0x0f],
		palette1: [0x22, 0x27, 0x17, 0x0f],
		palette2: [0x22, 0x29, 0x1a, 0x0f],
		palette3: [0x22, 0x30, 0x21, 0x0f]
	};
	const PALETTE_KEYS = Object.keys(DEFAULT_PALETTE_BYTES);
	const DEFAULT_RGB_COLORS = [
		"#666666", "#001fb2", "#2404c8", "#5200b2", "#730076", "#800024", "#730b00", "#522800",
		"#244400", "#005700", "#005c00", "#005324", "#003c76", "#000000", "#000000", "#000000",
		"#ababab", "#0d57ff", "#4b30ff", "#8a13ff", "#bc08d6", "#d21269", "#c72e00", "#994E00",
		"#607b00", "#209800", "#0c9300", "#009942", "#007db4", "#000000", "#000000", "#000000",
		"#ffffff", "#53aeff", "#9290FF", "#d365ff", "#ff57ff", "#ff5dcf", "#ff7757", "#ea9e22",
		"#bdc700", "#7ada00", "#43e641", "#26e59a", "#2acbf4", "#4e4e4e", "#000000", "#000000",
		"#ffffff", "#b6e1ff", "#ced1ff", "#e9c3ff", "#ffc0ff", "#ffc2e9", "#feccc5", "#f2da96",
		"#d8e898", "#bdeea9", "#a9f3c3", "#9ff3dd", "#a3ebff", "#b8b8b8", "#000000", "#000000"
	];

	// fallback color: 代替色，パレットやchrが読めないときこの色を使用
	const FALLBACK_COLORS = {
		"@": "#d9efff",
		"B": "#b85043",
		"G": "#4a9b54",
		"H": "#7a828d",
		"N": "#6e7782",
		"Q": "#d78b1f",
		"[": "#d78b1f",
		"^": "#d2a100",
		"_": "rgba(128,128,128,0.45)",
		"P": "#118447",
		"d": "#7a828d",
		"e": "#d2a100",
		bg: "#bcdcab"
	};

	const FLOOR_PATTERN_GROUND_HEIGHT = [0, 2, 2, 2, 2, 2, 5, 5, 5, 6, 0, 6, 9, 2, 2, 13];
	const FLOOR_PATTERN_CEILING_HEIGHT = [0, 0, 1, 3, 4, 8, 1, 3, 4, 1, 1, 4, 1, 1, 1, 0];
	const FLOOR_PATTERN_MIDDLE_START = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 0];
	const FLOOR_PATTERN_MIDDLE_HEIGHT = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 4, 0];

	const PIPE_SIZE_NAMES = ["SMB_PIPE_2ROW", "SMB_PIPE_3ROW", "SMB_PIPE_4ROW", "SMB_PIPE_5ROW"];
	const HOLE_SIZE_NAMES = ["", "SMB_HOLE_1COL", "SMB_HOLE_2COL", "SMB_HOLE_3COL"];

	const CONSTANTS = {
		SMB_OBJ_SINGLE: 0,
		SMB_OBJ_PLATFORM: 1,
		SMB_OBJ_BRICK_ROW: 2,
		SMB_OBJ_HARD_ROW: 3,
		SMB_OBJ_COIN_ROW: 4,
		SMB_OBJ_BRICK_COLUMN: 5,
		SMB_OBJ_HARD_COLUMN: 6,
		SMB_OBJ_PIPE: 7,
		OBJ_1: 0,
		OBJ_PLATFORM: 1,
		OBJ_BRICK_ROW: 2,
		OBJ_HARD_ROW: 3,
		OBJ_COIN_ROW: 4,
		OBJ_BRICK_COL: 5,
		OBJ_HARD_COL: 6,
		OBJ_PIPE: 7,
		SMB_SUB2_HOLE: 0,
		SMB_SUB2_QBLOCK_ROW: 6,
		SMB_SUB2_QBLOCK_POWERUP_ROW: 7,
		SP_HOLE: 0,
		SMB_SUB3_CASTLE: 2,
		SMB_SUB3_STAIRS: 3,
		SMB_SUB3_BIG_PIPE: 4,
		SMB_SUB3_STAIRS_REV: 5,
		SP_CASTLE: 2,
		SP_STAIRS: 3,
		SP_BIG_PIPE: 4,
		SP_STAIRS_REV: 5,
		SMB_CASTLE_SMALL: 0,
		CASTLE_SMALL: 0,
		SMB_PIPE_2ROW: 0,
		SMB_PIPE_3ROW: 1,
		SMB_PIPE_4ROW: 2,
		SMB_PIPE_5ROW: 3,
		PIPE_2: 0,
		PIPE_3: 1,
		PIPE_4: 2,
		PIPE_5: 3,
		SMB_HOLE_1COL: 1,
		SMB_HOLE_2COL: 2,
		SMB_HOLE_3COL: 3,
		SMB_STAIRS_4: 3,
		SMB_STAIRS_4_REVERSE: 3,
		SMB_STAIRS_8: 7,
		BLK_QP: 0,
		BLK_HIDE: 1,
		BLK_Q: 2,
		BLK_COIN: 3,
		BLK_BRICK: 4,
		BLK_HARD: 5,
		BLK_HARD2: 6,
		BLK_GROUND: 7,
		BLK_SKY: 8
	};

	for (const block of SINGLE_BLOCKS) {
		CONSTANTS[block.asm] = block.id;
	}

	const els = {};
	const undoStack = [];
	const redoStack = [];
	const chrState = {
		bytes: null,
		loaded: false,
		bgTileOffset: 0
	};
	let renderedCols = 0;
	let renderedWorld = null;
	let nextId = 1;
	let renderTimer = 0;
	let pointerAction = null;
	let selectionRect = null;
	let suppressNextClick = false;
	let editorMode = EDIT_MODE.DRAW;
	let activeEditEntry = null;

	const state = {
		label: "MAP_CUSTOM",
		header: {
			timer: 0,
			startY: 5,
			modifier: 0,
			floor: 0,
			scenery: 0,
			pattern: 1
		},
		bgScenery: 0,
		pages: [{ objects: [] }],
		currentPage: 0,
		selectedId: null,
		selectedIds: [],
		paletteBytes: clonePaletteBytes(),
		rgbColors: cloneRgbColors(),
		palettes: clonePalettes()
	};

	document.addEventListener("DOMContentLoaded", init);

	function init() {
		bindElements();
		buildGrid();
		bindEvents();
		buildEditDialogOptions();
		updateToolControls();
		updateEditorModeButtons();
		syncControlsFromState();
		exportPalettes({ silent: true });
		updateUndoButton();
		renderAll();
		loadDefaultPalette();
		loadDefaultChr();
	}

	function bindElements() {
		const ids = [
			"gridWrap", "mapGrid", "objectList", "statusText", "mapLabelInput", "timerInput", "startYInput",
			"mapCanvas",
			"selectModeButton", "drawModeButton", "eraseModeButton",
			"editObjectDialog", "editObjectTitle", "editObjectSummary", "editSingleKindField", "editSingleKindInput",
			"editSizeField", "editSizeLabel", "editSizeInput", "editCancelButton", "editApplyButton",
			"modifierInput", "floorInput", "sceneryInput", "patternInput", "bgSceneryInput", "toolKindInput",
			"singleKindInput", "singleKindField", "pipeKindInput", "pipeKindField", "sizeInput",
			"sizeField", "sizeLabel", "toolHint", "pageLabel", "addPageButton", "deletePageButton", "clearPageButton",
			"asmInput", "asmOutput", "importButton", "copyButton", "downloadButton",
			"chrFileInput", "chrReloadButton", "chrStatus", "chrPreviewCanvas",
			"paletteTargetInput", "paletteColor0Input", "paletteColor1Input", "paletteColor2Input", "paletteColor3Input",
			"palettePicker0Input", "palettePicker1Input", "palettePicker2Input", "palettePicker3Input",
			"paletteFileInput",
			"paletteText", "paletteImportButton", "paletteExportButton", "paletteResetButton",
			"scrollLeftButton", "scrollRightButton", "undoButton", "redoButton", "newMapButton", "saveLocalButton", "loadLocalButton"
		];

		for (const id of ids) {
			els[id] = document.getElementById(id);
		}
	}

	function buildGrid(totalCols = COLS) {
		els.mapGrid.innerHTML = "";
		els.mapGrid.style.setProperty("--map-columns", String(totalCols));
		els.mapGrid.style.setProperty("--map-rows", String(PLAY_ROWS));
		renderedCols = totalCols;

		const corner = labelCell("");
		corner.style.gridColumn = "1";
		corner.style.gridRow = "1";
		els.mapGrid.appendChild(corner);

		for (let worldX = 0; worldX < totalCols; worldX += 1) {
			const page = Math.floor(worldX / COLS);
			const localX = worldX % COLS;
			const label = localX === 0 ? `P${page}:0` : toHex(localX);
			const node = labelCell(label, localX === 0 ? "page-start" : "");
			node.classList.toggle("page-start", localX === 0);
			node.style.gridColumn = String(worldX + 2);
			node.style.gridRow = "1";
			node.title = `Page ${page}, X=$${toHex(localX)}`;
			els.mapGrid.appendChild(node);
		}

		for (let y = 0; y < PLAY_ROWS; y += 1) {
			const rowLabel = labelCell(`Y=$${toHex(y)}`, "row-label");
			rowLabel.style.gridColumn = "1";
			rowLabel.style.gridRow = String(y + 2);
			els.mapGrid.appendChild(rowLabel);
		}
	}
	function labelCell(text, extraClass = "") {
		const node = document.createElement("div");
		node.className = `grid-label ${extraClass}`.trim();
		node.textContent = text;
		return node;
	}
	function buildEditDialogOptions() {
		if (!els.editSingleKindInput) {
			return;
		}
		els.editSingleKindInput.innerHTML = SINGLE_BLOCKS
			.map((block) => `<option value="${block.id}">${block.glyph || "@"} ${block.label}</option>`)
			.join("");
	}

	function setEditorMode(mode) {
		if (!Object.values(EDIT_MODE).includes(mode)) {
			return;
		}
		editorMode = mode;
		selectionRect = null;
		pointerAction = null;
		updateEditorModeButtons();
		renderGrid();
	}

	function updateEditorModeButtons() {
		const buttons = [
			[els.selectModeButton, EDIT_MODE.SELECT],
			[els.drawModeButton, EDIT_MODE.DRAW],
			[els.eraseModeButton, EDIT_MODE.ERASE]
		];
		for (const [button, mode] of buttons) {
			if (!button) {
				continue;
			}
			const isActive = editorMode === mode;
			button.classList.toggle("is-active", isActive);
			button.setAttribute("aria-pressed", String(isActive));
		}
		if (els.mapCanvas) {
			els.mapCanvas.classList.toggle("mode-select", editorMode === EDIT_MODE.SELECT);
			els.mapCanvas.classList.toggle("mode-erase", editorMode === EDIT_MODE.ERASE);
			els.mapCanvas.classList.toggle("is-moving", pointerAction?.mode === "move" && pointerAction.didDrag);
		}
	}
	function originEntryAtPoint(point) {
		return renderedWorld?.origins.get(`${point.logicalWorldX}:${point.y}`) || null;
	}

	function isOriginHandleHit(event, point) {
		const entry = originEntryAtPoint(point);
		if (!entry) {
			return false;
		}
		const canvas = els.mapCanvas;
		const rect = canvas.getBoundingClientRect();
		const totalTileCols = Math.max(1, Math.round(canvas.width / TILE_CANVAS_SIZE));
		const tileCssSize = rect.width / totalTileCols;
		const blockCssSize = tileCssSize * 2;
		const localX = (event.clientX - rect.left) - point.logicalWorldX * blockCssSize;
		const localY = (event.clientY - rect.top) - point.y * blockCssSize;
		return localX >= blockCssSize - 16 && localX <= blockCssSize && localY >= 0 && localY <= 16;
	}

	function handleCanvasClickEvent(event) {
		if (suppressNextClick) {
			event.preventDefault();
			suppressNextClick = false;
			return;
		}

		const point = cellPointFromPointerEvent(event);
		if (!point) {
			return;
		}

		if (editorMode === EDIT_MODE.ERASE) {
			eraseAt(point.worldTileX, point.tileY);
			return;
		}

		const originEntry = originEntryAtPoint(point);
		if (originEntry && isOriginHandleHit(event, point)) {
			openObjectEditor(originEntry);
			return;
		}

		if (editorMode === EDIT_MODE.SELECT) {
			const found = findObjectAtCell(point.worldTileX, point.tileY);
			if (found) {
				state.currentPage = found.page;
				setSelectedIds([found.object.id]);
			} else {
				clearSelection();
			}
			renderAll();
			return;
		}

		handleCellClick(point.worldTileX, point.tileY);
	}
	function handleCanvasPointerDown(event) {
		if (event.button !== 0 || editorMode !== EDIT_MODE.SELECT) {
			return;
		}

		const point = cellPointFromPointerEvent(event);
		if (!point) {
			return;
		}

		event.preventDefault();
		pointerAction = {
			pointerId: event.pointerId,
			startCell: point,
			currentCell: point,
			startClientX: event.clientX,
			startClientY: event.clientY,
			didDrag: false,
			mode: null,
			moveIds: [],
			moveDx: 0,
			moveDy: 0
		};

		try {
			event.currentTarget.setPointerCapture(event.pointerId);
		} catch {
			// Pointer capture is best-effort; document listeners still handle the drag.
		}
	}
	function handleCanvasContextMenu(event) {
		event.preventDefault();
	}
	function updateCanvasTitleFromEvent(event) {
		const point = cellPointFromPointerEvent(event);
		if (!point || !renderedWorld) {
			return;
		}

		const cell = renderedWorld.cells[point.y]?.[point.logicalWorldX] || null;
		const originEntry = renderedWorld.origins.get(`${point.logicalWorldX}:${point.y}`);
		const block = BLOCK_BY_CHAR[cell?.char || "@"] || BLOCK_BY_CHAR["@"];
		els.mapCanvas.title = originEntry
			? `Page ${originEntry.page}, ${objectLabel(originEntry.object)}`
			: `Page ${point.page}, X=$${toHex(point.x)}, Y=$${toHex(point.y)} ${block.label}`;
	}
	function handleDocumentPointerMove(event) {
		if (!pointerAction || pointerAction.pointerId !== event.pointerId) {
			return;
		}

		const current = cellPointFromPointerEvent(event) || pointerAction.currentCell;
		pointerAction.currentCell = current;

		if (!pointerAction.didDrag) {
			const distance = Math.hypot(event.clientX - pointerAction.startClientX, event.clientY - pointerAction.startClientY);
			if (distance < 6) {
				return;
			}
			startPointerDrag();
		}

		if (pointerAction.mode === "select") {
			selectionRect = normalizedSelectionRect(pointerAction.startCell, current);
			setStatus(`Range ${selectionRect.left}:${selectionRect.top} - ${selectionRect.right}:${selectionRect.bottom}`);
		} else if (pointerAction.mode === "move") {
			pointerAction.moveDx = clampedMoveDx(pointerAction.moveIds, current.logicalWorldX - pointerAction.startCell.logicalWorldX);
			pointerAction.moveDy = current.y - pointerAction.startCell.y;
			setStatus(`Move X ${pointerAction.moveDx >= 0 ? "+" : ""}${pointerAction.moveDx}, Y ${pointerAction.moveDy >= 0 ? "+" : ""}${pointerAction.moveDy}`);
		}

		renderGrid();
	}

	function handleDocumentPointerUp(event) {
		if (!pointerAction || pointerAction.pointerId !== event.pointerId) {
			return;
		}

		const action = pointerAction;
		pointerAction = null;

		if (!action.didDrag) {
			selectionRect = null;
			return;
		}

		suppressNextClick = true;
		if (action.mode === "select") {
			const ids = objectsInSelectionRect(selectionRect);
			setSelectedIds(ids);
			selectionRect = null;
			setStatus(ids.length ? `${ids.length} object(s) selected.` : "Selection is empty.");
			renderAll();
			return;
		}

		if (action.mode === "move") {
			selectionRect = null;
			moveSelectedObjectsBy(action.moveIds, action.moveDx, action.moveDy);
			return;
		}

		selectionRect = null;
		renderAll();
	}

	function cancelPointerAction() {
		pointerAction = null;
		selectionRect = null;
		renderGrid();
	}

	function startPointerDrag() {
		pointerAction.didDrag = true;
		suppressNextClick = true;
		const entry = findObjectAtCell(pointerAction.startCell.worldTileX, pointerAction.startCell.tileY);
		if (entry) {
			if (!isObjectSelected(entry.object.id)) {
				setSelectedIds([entry.object.id]);
			}
			pointerAction.mode = "move";
			pointerAction.moveIds = selectionIds();
			return;
		}

		pointerAction.mode = "select";
		selectionRect = normalizedSelectionRect(pointerAction.startCell, pointerAction.currentCell);
	}

	function cellPointFromTile(worldTileX, tileY) {
		const page = pageFromTileX(worldTileX);
		const x = localXFromTileX(worldTileX);
		return {
			worldTileX,
			tileY,
			page,
			x,
			logicalWorldX: page * COLS + x,
			y: logicalYFromTileY(tileY)
		};
	}

	function cellPointFromPointerEvent(event) {
		const canvas = els.mapCanvas;
		if (!canvas) {
			return null;
		}

		const rect = canvas.getBoundingClientRect();
		const cssX = event.clientX - rect.left;
		const cssY = event.clientY - rect.top;
		if (cssX < 0 || cssY < 0 || cssX >= rect.width || cssY >= rect.height) {
			return null;
		}

		const totalTileCols = Math.max(1, Math.round(canvas.width / TILE_CANVAS_SIZE));
		const totalTileRows = Math.max(1, Math.round(canvas.height / TILE_CANVAS_SIZE));
		const tileX = clampNumber(Math.floor(cssX / (rect.width / totalTileCols)), 0, totalTileCols - 1);
		const tileY = clampNumber(Math.floor(cssY / (rect.height / totalTileRows)), 0, totalTileRows - 1);
		return cellPointFromTile(tileX, tileY);
	}
	function normalizedSelectionRect(a, b) {
		return {
			left: Math.min(a.logicalWorldX, b.logicalWorldX),
			right: Math.max(a.logicalWorldX, b.logicalWorldX),
			top: Math.min(a.y, b.y),
			bottom: Math.max(a.y, b.y)
		};
	}

	function rectContains(rect, x, y) {
		return Boolean(rect) && x >= rect.left && x <= rect.right && y >= rect.top && y <= rect.bottom;
	}

	function objectsInSelectionRect(rect) {
		if (!rect) {
			return [];
		}

		const world = buildWorld();
		return sortedObjects(world.entries)
			.filter((entry) => {
				const originX = entry.page * COLS + entry.object.x;
				if (rectContains(rect, originX, entry.object.y)) {
					return true;
				}
				return entry.footprint.some((pos) => rectContains(rect, pos.x, pos.y));
			})
			.map((entry) => entry.object.id);
	}

	function selectionIds() {
		if (Array.isArray(state.selectedIds) && state.selectedIds.length > 0) {
			return state.selectedIds.filter((id) => Number.isFinite(id));
		}
		return state.selectedId === null ? [] : [state.selectedId];
	}

	function setSelectedIds(ids) {
		const unique = [];
		for (const id of ids || []) {
			const numericId = Number(id);
			if (Number.isFinite(numericId) && !unique.includes(numericId)) {
				unique.push(numericId);
			}
		}
		state.selectedIds = unique;
		state.selectedId = unique.length ? unique[unique.length - 1] : null;
	}

	function clearSelection() {
		setSelectedIds([]);
	}

	function isObjectSelected(id) {
		return selectionIds().includes(id);
	}

	function selectedIdSet() {
		return new Set(selectionIds());
	}

	function selectedCellsForWorld(world) {
		const ids = selectedIdSet();
		const cells = new Set();
		for (const entry of world.entries) {
			if (!ids.has(entry.object.id)) {
				continue;
			}
			for (const pos of entry.footprint) {
				cells.add(`${pos.x}:${pos.y}`);
			}
		}
		return cells;
	}

	function movingPreviewCellsForWorld(world) {
		const cells = new Set();
		if (!pointerAction || pointerAction.mode !== "move" || !pointerAction.didDrag) {
			return cells;
		}

		const ids = new Set(pointerAction.moveIds);
		for (const entry of world.entries) {
			if (!ids.has(entry.object.id)) {
				continue;
			}
			const objectDy = movedObjectY(entry.object, pointerAction.moveDy) - entry.object.y;
			for (const pos of entry.footprint) {
				const x = pos.x + pointerAction.moveDx;
				const y = pos.y + objectDy;
				if (x >= 0 && y >= 0 && y < PLAY_ROWS) {
					cells.add(`${x}:${y}`);
				}
			}
		}
		return cells;
	}

	function clampedMoveDx(ids, dx) {
		const entries = entriesForIds(ids);
		if (entries.length === 0) {
			return 0;
		}
		const totalCols = state.pages.length * COLS;
		const origins = entries.map((entry) => entry.page * COLS + entry.object.x);
		return clampNumber(dx, -Math.min(...origins), totalCols - 1 - Math.max(...origins));
	}

	function entriesForIds(ids) {
		const idSet = new Set(ids || []);
		return allObjectsWithPage().filter((entry) => idSet.has(entry.object.id));
	}

	function movedObjectY(object, dy) {
		if (object.y === 12 && object.type === TYPE.HOLE) {
			return 12;
		}
		if (object.y === 15 && [TYPE.CASTLE, TYPE.STAIRS, TYPE.STAIRS_REV, TYPE.BIG_PIPE].includes(object.type)) {
			return 15;
		}
		return clampNumber(object.y + dy, 0, 11);
	}

	function moveSelectedObjectsBy(ids, dx, dy) {
		const moveIds = [...new Set(ids || [])];
		const entries = entriesForIds(moveIds);
		if (entries.length === 0) {
			renderAll();
			return;
		}

		const clampedDx = clampedMoveDx(moveIds, dx);
		const moves = entries.map((entry) => {
			const worldX = entry.page * COLS + entry.object.x + clampedDx;
			return {
				object: entry.object,
				page: Math.floor(worldX / COLS),
				x: ((worldX % COLS) + COLS) % COLS,
				y: movedObjectY(entry.object, dy)
			};
		});

		const changed = moves.some((move, index) => {
			const entry = entries[index];
			return move.page !== entry.page || move.x !== entry.object.x || move.y !== entry.object.y;
		});
		if (!changed) {
			setStatus("Move did not change the selection.");
			renderAll();
			return;
		}

		pushHistory();
		const idSet = new Set(moveIds);
		for (const page of state.pages) {
			page.objects = page.objects.filter((object) => !idSet.has(object.id));
		}
		for (const move of moves) {
			move.object.x = move.x;
			move.object.y = move.y;
			state.pages[move.page].objects.push(move.object);
		}
		state.currentPage = moves[0].page;
		setSelectedIds(moveIds);
		setStatus(`${moveIds.length} object(s) moved.`);
		renderAll();
		scrollToCurrentPage();
	}

	function deleteSelectedObjects() {
		const ids = selectionIds();
		if (ids.length === 0) {
			return;
		}
		if (ids.length === 1) {
			deleteObject(ids[0]);
			return;
		}

		pushHistory();
		const idSet = new Set(ids);
		for (const page of state.pages) {
			page.objects = page.objects.filter((object) => !idSet.has(object.id));
		}
		clearSelection();
		setStatus(`${ids.length} object(s) deleted.`);
		renderAll();
	}

	function bindEvents() {
		els.mapLabelInput.addEventListener("input", () => {
			pushHistory();
			state.label = sanitizeLabel(els.mapLabelInput.value);
			scheduleOutput();
		});

		for (const [id, key] of [
			["timerInput", "timer"],
			["startYInput", "startY"],
			["modifierInput", "modifier"],
			["floorInput", "floor"],
			["sceneryInput", "scenery"],
			["patternInput", "pattern"]
		]) {
			els[id].addEventListener("input", () => {
				pushHistory();
				state.header[key] = clampNumber(els[id].value, 0, key === "pattern" ? 15 : 7);
				renderAll();
			});
		}

		els.bgSceneryInput.addEventListener("change", () => {
			pushHistory();
			state.bgScenery = clampNumber(els.bgSceneryInput.value, -1, 1);
			renderAll();
		});

		els.toolKindInput.addEventListener("change", updateToolControls);
		els.selectModeButton.addEventListener("click", () => setEditorMode(EDIT_MODE.SELECT));
		els.drawModeButton.addEventListener("click", () => setEditorMode(EDIT_MODE.DRAW));
		els.eraseModeButton.addEventListener("click", () => setEditorMode(EDIT_MODE.ERASE));
		els.editApplyButton.addEventListener("click", applyObjectEditor);
		els.editCancelButton.addEventListener("click", () => closeObjectEditor());
		els.editObjectDialog.addEventListener("cancel", () => closeObjectEditor());
		els.singleKindInput.addEventListener("change", updateToolControls);
		els.pipeKindInput.addEventListener("change", updateToolControls);
		els.sizeInput.addEventListener("input", updateToolControls);
		els.mapCanvas.addEventListener("click", handleCanvasClickEvent);
		els.mapCanvas.addEventListener("pointerdown", handleCanvasPointerDown);
		els.mapCanvas.addEventListener("contextmenu", handleCanvasContextMenu);
		els.mapCanvas.addEventListener("pointermove", updateCanvasTitleFromEvent);
		els.addPageButton.addEventListener("click", addPage);
		els.deletePageButton.addEventListener("click", deletePage);
		els.clearPageButton.addEventListener("click", clearCurrentPage);
		els.scrollLeftButton.addEventListener("click", () => scrollGridBy(-1));
		els.scrollRightButton.addEventListener("click", () => scrollGridBy(1));
		els.chrFileInput.addEventListener("change", handleChrFileChange);
		els.chrReloadButton.addEventListener("click", loadDefaultChr);
		els.paletteTargetInput.addEventListener("change", syncPaletteControls);
		for (let index = 0; index < 4; index += 1) {
			els[`paletteColor${index}Input`].addEventListener("change", () => updatePaletteColorFromHex(index));
			els[`palettePicker${index}Input`].addEventListener("input", () => updatePaletteColorFromPicker(index));
		}
		els.paletteFileInput.addEventListener("change", handlePalFileChange);
		els.paletteExportButton.addEventListener("click", exportPalettes);
		els.paletteImportButton.addEventListener("click", importPalettes);
		els.paletteResetButton.addEventListener("click", resetPalettes);

		els.importButton.addEventListener("click", importAsm);
		els.copyButton.addEventListener("click", copyOutput);
		els.downloadButton.addEventListener("click", downloadOutput);
		els.undoButton.addEventListener("click", undoLast);
		els.redoButton.addEventListener("click", redoLast);
		els.newMapButton.addEventListener("click", resetMap);
		els.saveLocalButton.addEventListener("click", saveLocal);
		els.loadLocalButton.addEventListener("click", loadLocal);

		els.objectList.addEventListener("click", (event) => {
			const button = event.target.closest("button[data-action]");
			if (!button) {
				return;
			}

			const row = button.closest("tr[data-id]");
			if (!row) {
				return;
			}

			const id = Number(row.dataset.id);
			const pageIndex = clampNumber(row.dataset.page, 0, state.pages.length - 1);
			const action = button.dataset.action;
			if (action === "select") {
				state.currentPage = pageIndex;
				setSelectedIds([id]);
				renderAll();
				scrollToCurrentPage();
			} else if (action === "duplicate") {
				duplicateObject(id, pageIndex);
			} else if (action === "delete") {
				deleteObject(id, pageIndex);
			}
		});

		document.addEventListener("pointermove", handleDocumentPointerMove);
		document.addEventListener("pointerup", handleDocumentPointerUp);
		document.addEventListener("pointercancel", cancelPointerAction);

		document.addEventListener("keydown", (event) => {
			if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "z") {
				event.preventDefault();
				if (event.shiftKey) {
					redoLast();
				} else {
					undoLast();
				}
				return;
			}

			if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "y") {
				event.preventDefault();
				redoLast();
				return;
			}

			if (event.key === "Delete" && selectionIds().length > 0) {
				deleteSelectedObjects();
			}
		});
	}

	function updateToolControls() {
		const kind = els.toolKindInput.value;
		const isSingle = kind === "single";
		const isPipe = kind === "pipe";
		const noSize = isSingle || isPipe || kind === "castle" || kind === "bigPipe";

		els.singleKindField.classList.toggle("is-hidden", !isSingle);
		els.pipeKindField.classList.toggle("is-hidden", !isPipe);
		els.sizeField.classList.toggle("is-hidden", noSize);

		let label = "サイズ";
		let hint = "配置モードでクリックすると配置します。削除は中央ツールバーの削除モードを使います。";
		let min = 1;
		let max = 15;
		let value = Number(els.sizeInput.value) || 1;

		if (kind.includes("Row") || kind === "hole") {
			label = "横幅";
			max = kind === "hole" ? 3 : 15;
		} else if (kind.includes("Column")) {
			label = "高さ";
			max = 13;
		} else if (kind === "stairs" || kind === "stairsRev") {
			label = "横幅";
		} else if (kind === "pipe") {
			hint = "配置モードでクリックした位置を土管の上端として配置します。";
		}

		els.sizeLabel.textContent = label;
		els.sizeInput.min = String(min);
		els.sizeInput.max = String(max);
		els.sizeInput.value = String(clampNumber(value, min, max));
		els.toolHint.textContent = hint;
	}
	function handleCellClick(worldTileX, tileY) {
		const page = pageFromTileX(worldTileX);
		const x = localXFromTileX(worldTileX);
		const y = logicalYFromTileY(tileY);
		pushHistory();
		state.currentPage = page;

		if (els.toolKindInput.value === "single") {
			const singleY = clampNumber(y, 0, 11);
			const singleSize = clampNumber(els.singleKindInput.value, 0, 8);
			const existing = findSingleObjectAt(page, x, singleY);

			if (existing) {
				existing.object.size = singleSize;
				setSelectedIds([existing.object.id]);
				setStatus(`${objectLabel(existing.object)} に置き換えました。`);
				renderAll();
				return;
			}
		}

		const object = createObjectFromTool(x, y);
		currentObjects().push(object);
		setSelectedIds([object.id]);
		setStatus(`${objectLabel(object)} を追加しました。`);
		renderAll();
	}

	function createObjectFromTool(x, y) {
		const kind = els.toolKindInput.value;
		const size = clampNumber(els.sizeInput.value, 1, 15);
		const object = {
			id: nextId++,
			order: nextId,
			x: clampNumber(x, 0, 15),
			y: clampNumber(y, 0, 15),
			type: TYPE.SINGLE,
			size: 0
		};

		if (kind === "single") {
			object.y = clampNumber(y, 0, 11);
			object.type = TYPE.SINGLE;
			object.size = clampNumber(els.singleKindInput.value, 0, 8);
		} else if (kind === "brickRow") {
			setLinearObject(object, y, TYPE.BRICK_ROW, size);
		} else if (kind === "hardRow") {
			setLinearObject(object, y, TYPE.HARD_ROW, size);
		} else if (kind === "coinRow") {
			setLinearObject(object, y, TYPE.COIN_ROW, size);
		} else if (kind === "brickColumn") {
			setLinearObject(object, y, TYPE.BRICK_COLUMN, clampNumber(size, 1, 13));
		} else if (kind === "hardColumn") {
			setLinearObject(object, y, TYPE.HARD_COLUMN, clampNumber(size, 1, 13));
		} else if (kind === "pipe") {
			object.y = clampNumber(y, 0, 11);
			object.type = TYPE.PIPE;
			object.size = clampNumber(els.pipeKindInput.value, 0, 3);
		} else if (kind === "hole") {
			object.y = 12;
			object.type = TYPE.HOLE;
			object.size = size;
		} else if (kind === "stairs") {
			object.y = 15;
			object.type = TYPE.STAIRS;
			object.size = clampNumber(size, 1, 15) - 1;
		} else if (kind === "stairsRev") {
			object.y = 15;
			object.type = TYPE.STAIRS_REV;
			object.size = clampNumber(size, 1, 15) - 1;
		} else if (kind === "castle") {
			object.y = 15;
			object.type = TYPE.CASTLE;
			object.size = 0;
		} else if (kind === "bigPipe") {
			object.y = 15;
			object.type = TYPE.BIG_PIPE;
			object.size = 0;
		}

		return object;
	}

	function setLinearObject(object, y, type, size) {
		object.y = clampNumber(y, 0, 11);
		object.type = type;
		object.size = size;
	}

	function eraseAt(worldTileX, tileY) {
		const found = findObjectAtCell(worldTileX, tileY);
		if (!found) {
			setStatus("削除対象がありません。");
			return;
		}

		deleteObject(found.object.id, found.page);
	}

	function findObjectAtCell(worldTileX, tileY) {
		const world = buildWorld();
		const page = pageFromTileX(worldTileX);
		const localX = localXFromTileX(worldTileX);
		const logicalWorldX = page * COLS + localX;
		const y = logicalYFromTileY(tileY);
		const candidates = sortedObjects(world.entries)
			.filter((entry) => {
				const isOrigin = entry.page === page && entry.object.x === localX && entry.object.y === y;
				const coversCell = entry.footprint.some((pos) => pos.x === logicalWorldX && pos.y === y);
				return isOrigin || coversCell;
			});

		for (let i = candidates.length - 1; i >= 0; i -= 1) {
			const entry = candidates[i];
			return entry;
		}

		return world.origins.get(`${logicalWorldX}:${y}`) || null;
	}

	function findSingleObjectAt(pageIndex, x, y) {
		const object = currentObjects(pageIndex).find((item) => {
			return item.type === TYPE.SINGLE && item.y < PLAY_ROWS && item.x === x && item.y === y;
		});

		return object ? { object, page: pageIndex } : null;
	}
	function openObjectEditor(entry) {
		activeEditEntry = entry;
		state.currentPage = entry.page;
		setSelectedIds([entry.object.id]);
		els.editObjectTitle.textContent = "オブジェクト編集";
		els.editObjectSummary.textContent = `Page ${entry.page}, X=${toHex(entry.object.x)}, Y=${toHex(entry.object.y)} ${objectLabel(entry.object)}`;

		const isSingle = entry.object.type === TYPE.SINGLE && entry.object.y < PLAY_ROWS;
		const sizeConfig = editableSizeConfig(entry.object);
		els.editSingleKindField.classList.toggle("is-hidden", !isSingle);
		els.editSizeField.classList.toggle("is-hidden", !sizeConfig);
		if (isSingle) {
			els.editSingleKindInput.value = String(entry.object.size);
		}
		if (sizeConfig) {
			els.editSizeLabel.textContent = sizeConfig.label;
			els.editSizeInput.min = String(sizeConfig.min);
			els.editSizeInput.max = String(sizeConfig.max);
			els.editSizeInput.value = String(sizeConfig.value);
		}

		if (!isSingle && !sizeConfig) {
			els.editObjectSummary.textContent += " / 編集できるプロパティはありません";
		}
		els.editObjectDialog.showModal();
		renderAll();
	}

	function closeObjectEditor() {
		activeEditEntry = null;
		if (els.editObjectDialog?.open) {
			els.editObjectDialog.close();
		}
	}

	function applyObjectEditor(event) {
		event.preventDefault();
		if (!activeEditEntry) {
			closeObjectEditor();
			return;
		}

		const object = activeEditEntry.object;
		const isSingle = object.type === TYPE.SINGLE && object.y < PLAY_ROWS;
		const sizeConfig = editableSizeConfig(object);
		pushHistory();
		if (isSingle) {
			object.size = clampNumber(els.editSingleKindInput.value, 0, 8);
		}
		if (sizeConfig) {
			const value = clampNumber(els.editSizeInput.value, sizeConfig.min, sizeConfig.max);
			object.size = sizeConfig.toStored(value);
		}
		state.currentPage = activeEditEntry.page;
		setSelectedIds([object.id]);
		setStatus("オブジェクトを更新しました。");
		closeObjectEditor();
		renderAll();
	}

	function editableSizeConfig(object) {
		if (object.type === TYPE.BRICK_ROW || object.type === TYPE.HARD_ROW || object.type === TYPE.COIN_ROW) {
			return { label: "横幅", min: 1, max: 15, value: sizeOrOne(object.size), toStored: (value) => value };
		}
		if (object.type === TYPE.BRICK_COLUMN || object.type === TYPE.HARD_COLUMN) {
			return { label: "高さ", min: 1, max: 13, value: sizeOrOne(object.size), toStored: (value) => value };
		}
		if (object.type === TYPE.PIPE && object.y !== 15) {
			return { label: "高さ", min: 2, max: 5, value: object.size + 2, toStored: (value) => value - 2 };
		}
		if (object.y === 12 && object.type === TYPE.HOLE) {
			return { label: "横幅", min: 1, max: 3, value: sizeOrOne(object.size), toStored: (value) => value };
		}
		if (object.y === 15 && (object.type === TYPE.STAIRS || object.type === TYPE.STAIRS_REV)) {
			return { label: "横幅", min: 1, max: 15, value: object.size + 1, toStored: (value) => value - 1 };
		}
		return null;
	}

	function duplicateObject(id, pageIndex = null) {
		const entry = entryForObjectId(id, pageIndex);
		if (!entry) {
			return;
		}

		pushHistory();
		const copy = {
			...entry.object,
			id: nextId++,
			order: nextId,
			x: clampNumber(entry.object.x + 1, 0, 15)
		};
		currentObjects(entry.page).push(copy);
		state.currentPage = entry.page;
		setSelectedIds([copy.id]);
		setStatus("オブジェクトを複製しました。");
		renderAll();
	}

	function entryForObjectId(id, pageIndex = null) {
		if (pageIndex !== null && pageIndex !== undefined && state.pages[pageIndex]) {
			const object = state.pages[pageIndex].objects.find((item) => item.id === id);
			if (object) {
				return { object, page: pageIndex };
			}
		}
		for (let page = 0; page < state.pages.length; page += 1) {
			const object = state.pages[page].objects.find((item) => item.id === id);
			if (object) {
				return { object, page };
			}
		}
		return null;
	}
	function deleteObject(id, pageIndex = state.currentPage) {
		const objects = currentObjects(pageIndex);
		const index = objects.findIndex((item) => item.id === id);
		if (index === -1) {
			return;
		}

		pushHistory();
		state.currentPage = pageIndex;
		objects.splice(index, 1);
		setSelectedIds(selectionIds().filter((selectedId) => selectedId !== id));
		setStatus("オブジェクトを削除しました。");
		renderAll();
	}

	function renderAll() {
		renderPageControls();
		renderGrid();
		renderObjectList();
		scheduleOutput();
	}

	function renderPageControls() {
		els.pageLabel.textContent = `Page ${state.currentPage} / ${state.pages.length - 1}`;
		els.deletePageButton.disabled = state.pages.length <= 1;
		updateUndoButton();
	}

	function renderGrid() {
		const totalCols = Math.max(COLS, state.pages.length * COLS);
		if (renderedCols !== totalCols) {
			buildGrid(totalCols);
		}

		const totalTileCols = totalCols * 2;
		const world = buildWorld();
		renderedWorld = world;
		renderMapCanvas(world, totalTileCols);
	}
	function blockHasRenderedTile(world, logicalWorldX, logicalY) {
		for (let dy = 0; dy < 2; dy += 1) {
			for (let dx = 0; dx < 2; dx += 1) {
				const tileX = logicalWorldX * 2 + dx;
				const tileY = logicalY * 2 + dy;
				const quadrant = dy * 2 + dx;
				const cell = world.cells[logicalY]?.[logicalWorldX] || null;
				const bgTile = world.bgTiles[tileY]?.[tileX] || 0;
				const bgPalette = world.bgPalettes[tileY]?.[tileX] || 0;
				const tileInfo = tileInfoForCell(cell, quadrant, bgTile, bgPalette);
				if (tileInfo.tile || tileInfo.underTile) {
					return true;
				}
			}
		}
		return false;
	}

	function renderObjectList() {
		els.objectList.innerHTML = "";
		const objects = sortedObjects(allObjectsWithPage());

		if (objects.length === 0) {
			const row = document.createElement("tr");
			row.innerHTML = `<td colspan="6">配置済みオブジェクトはありません。</td>`;
			els.objectList.appendChild(row);
			return;
		}

		for (const entry of objects) {
			const object = entry.object;
			const row = document.createElement("tr");
			row.dataset.id = String(object.id);
			row.dataset.page = String(entry.page);
			row.classList.toggle("selected-row", isObjectSelected(object.id));
			row.innerHTML = `
        <td>${entry.page}</td>
        <td>${toHex(object.x)}</td>
        <td>${toHex(object.y)}</td>
        <td>${escapeHtml(objectLabel(object))}</td>
        <td>${toHex(object.size)}</td>
        <td class="actions">
          <button type="button" data-action="select">選択</button>
          <button type="button" data-action="duplicate">複製</button>
          <button type="button" data-action="delete" class="danger">削除</button>
        </td>
      `;
			els.objectList.appendChild(row);
		}
	}
	function renderMapCanvas(world, totalCols) {
		const canvas = els.mapCanvas;
		if (!canvas) {
			return;
		}

		canvas.width = totalCols * TILE_CANVAS_SIZE;
		canvas.height = TILE_ROWS * TILE_CANVAS_SIZE;
		canvas.style.width = `${totalCols * TILE_CSS_SIZE}px`;
		canvas.style.height = `${TILE_ROWS * TILE_CSS_SIZE}px`;

		const ctx = canvas.getContext("2d");
		ctx.imageSmoothingEnabled = false;
		ctx.fillStyle = mapBackgroundColor();
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		for (let y = 0; y < TILE_ROWS; y += 1) {
			for (let x = 0; x < totalCols; x += 1) {
				const page = pageFromTileX(x);
				const logicalX = localXFromTileX(x);
				const logicalWorldX = page * COLS + logicalX;
				const logicalY = logicalYFromTileY(y);
				const quadrant = (y % 2) * 2 + (x % 2);
				const cell = world.cells[logicalY]?.[logicalWorldX] || null;
				const bgTile = world.bgTiles[y]?.[x] || 0;
				const bgPalette = world.bgPalettes[y]?.[x] || 0;
				const tileInfo = tileInfoForCell(cell, quadrant, bgTile, bgPalette);
				const dx = x * TILE_CANVAS_SIZE;
				const dy = y * TILE_CANVAS_SIZE;

				if (chrState.loaded && tileInfo.underTile) {
					drawChrTile(ctx, bgTileIndex(tileInfo.underTile), dx, dy, paletteForTileKey(tileInfo.underPaletteKey));
				}
				if (chrState.loaded && tileInfo.tile) {
					drawChrTile(ctx, bgTileIndex(tileInfo.tile), dx, dy, paletteForTileKey(tileInfo.paletteKey), drawOptionsForTile(tileInfo));
				} else {
					ctx.fillStyle = fallbackColor(tileInfo, cell);
					ctx.fillRect(dx, dy, TILE_CANVAS_SIZE, TILE_CANVAS_SIZE);
				}
			}
		}

		drawEditorOverlay(ctx, world, totalCols);
	}

	function drawEditorOverlay(ctx, world, totalTileCols) {
		const logicalCols = Math.floor(totalTileCols / 2);
		const selectedCells = selectedCellsForWorld(world);
		const movingCells = movingPreviewCellsForWorld(world);

		if (!chrState.loaded) {
			drawFallbackGlyphs(ctx, world, logicalCols);
		}

		drawBlockGrid(ctx, logicalCols);
		drawSelectionRange(ctx, logicalCols);
		drawCellSet(ctx, selectedCells, logicalCols, {
			strokeStyle: "rgba(0, 127, 95, 0.95)",
			lineWidth: 2
		});
		drawCellSet(ctx, movingCells, logicalCols, {
			fillStyle: "rgba(0, 102, 77, 0.1)",
			strokeStyle: "rgba(0, 102, 77, 0.95)",
			lineWidth: 2
		});
		drawOriginDots(ctx, world, logicalCols);
	}

	function drawFallbackGlyphs(ctx, world, logicalCols) {
		const blockSize = TILE_CANVAS_SIZE * 2;
		ctx.save();
		ctx.font = "bold 10px sans-serif";
		ctx.textAlign = "center";
		ctx.textBaseline = "middle";
		for (let y = 0; y < PLAY_ROWS; y += 1) {
			for (let x = 0; x < logicalCols; x += 1) {
				const cell = world.cells[y]?.[x] || null;
				const block = BLOCK_BY_CHAR[cell?.char || "@"] || BLOCK_BY_CHAR["@"];
				if (!block.glyph) {
					continue;
				}
				ctx.fillStyle = block.className === "hidden-qblock" ? "rgba(70, 76, 84, 0.7)" : "rgba(15, 35, 45, 0.92)";
				ctx.fillText(block.glyph, x * blockSize + blockSize / 2, y * blockSize + blockSize / 2 + 0.5);
			}
		}
		ctx.restore();
	}

	function drawBlockGrid(ctx, logicalCols) {
		const blockSize = TILE_CANVAS_SIZE * 2;
		const width = logicalCols * blockSize;
		const height = PLAY_ROWS * blockSize;

		ctx.save();
		ctx.lineWidth = 1;
		ctx.strokeStyle = "rgba(32, 36, 43, 0.22)";
		ctx.beginPath();
		for (let x = 0; x <= logicalCols; x += 1) {
			const px = x * blockSize + 0.5;
			ctx.moveTo(px, 0);
			ctx.lineTo(px, height);
		}
		for (let y = 0; y <= PLAY_ROWS; y += 1) {
			const py = y * blockSize + 0.5;
			ctx.moveTo(0, py);
			ctx.lineTo(width, py);
		}
		ctx.stroke();

		ctx.strokeStyle = "rgba(0, 127, 95, 0.65)";
		ctx.beginPath();
		for (let x = 0; x <= logicalCols; x += COLS) {
			const px = x * blockSize + 0.5;
			ctx.moveTo(px, 0);
			ctx.lineTo(px, height);
		}
		ctx.stroke();
		ctx.restore();
	}

	function drawSelectionRange(ctx, logicalCols) {
		if (!selectionRect) {
			return;
		}

		const blockSize = TILE_CANVAS_SIZE * 2;
		const left = clampNumber(selectionRect.left, 0, logicalCols - 1);
		const right = clampNumber(selectionRect.right, 0, logicalCols - 1);
		const top = clampNumber(selectionRect.top, 0, PLAY_ROWS - 1);
		const bottom = clampNumber(selectionRect.bottom, 0, PLAY_ROWS - 1);
		ctx.save();
		ctx.fillStyle = "rgba(0, 127, 95, 0.18)";
		ctx.strokeStyle = "rgba(0, 127, 95, 0.55)";
		ctx.lineWidth = 1;
		ctx.fillRect(left * blockSize, top * blockSize, (right - left + 1) * blockSize, (bottom - top + 1) * blockSize);
		ctx.strokeRect(left * blockSize + 0.5, top * blockSize + 0.5, (right - left + 1) * blockSize - 1, (bottom - top + 1) * blockSize - 1);
		ctx.restore();
	}

	function drawCellSet(ctx, cells, logicalCols, options) {
		if (!cells || cells.size === 0) {
			return;
		}

		const blockSize = TILE_CANVAS_SIZE * 2;
		ctx.save();
		ctx.lineWidth = options.lineWidth || 1;
		ctx.fillStyle = options.fillStyle || "transparent";
		ctx.strokeStyle = options.strokeStyle || "rgba(0, 127, 95, 0.95)";
		for (const key of cells) {
			const [x, y] = key.split(":").map(Number);
			if (x < 0 || x >= logicalCols || y < 0 || y >= PLAY_ROWS) {
				continue;
			}
			const px = x * blockSize;
			const py = y * blockSize;
			if (options.fillStyle) {
				ctx.fillRect(px, py, blockSize, blockSize);
			}
			ctx.strokeRect(px + 1, py + 1, blockSize - 2, blockSize - 2);
		}
		ctx.restore();
	}

	function drawOriginDots(ctx, world, logicalCols) {
		const blockSize = TILE_CANVAS_SIZE * 2;
		const selectedIds = selectedIdSet();
		ctx.save();
		for (const [key, originEntry] of world.origins) {
			const [x, y] = key.split(":").map(Number);
			if (x < 0 || x >= logicalCols || y < 0 || y >= PLAY_ROWS) {
				continue;
			}
			ctx.fillStyle = selectedIds.has(originEntry.object.id) ? "rgba(0, 102, 77, 1)" : "rgba(0, 127, 95, 0.9)";
			ctx.beginPath();
			ctx.arc(x * blockSize + blockSize - 5, y * blockSize + 5, 4, 0, Math.PI * 2);
			ctx.fill();
		}
		ctx.restore();
	}
	function scheduleOutput() {
		window.clearTimeout(renderTimer);
		renderTimer = window.setTimeout(() => {
			els.asmOutput.value = exportAsm();
		}, 0);
	}

	function buildWorld() {
		const totalCols = Math.max(1, state.pages.length * COLS + 16);
		const cells = Array.from({ length: ROWS }, () => Array.from({ length: totalCols }, () => ({ char: "@", tileKey: "@" })));
		const bgTileCols = Math.max(TILE_COLS_PER_PAGE, state.pages.length * TILE_COLS_PER_PAGE + TILE_COLS_PER_PAGE);
		const bgTiles = buildBgTileLayer(bgTileCols);
		const bgPalettes = buildBgPaletteLayer(bgTileCols);
		const origins = new Map();
		const entries = [];
		const base = baseFloorInfo();

		for (let x = 0; x < totalCols; x += 1) {
			applyBaseColumn(cells, x, base);
		}

		for (const entry of sortedObjects(allObjectsWithPage())) {
			const footprint = applyObject(cells, entry.object, entry.page, base);
			const completedEntry = { ...entry, footprint };
			const originPoint = displayOriginPoint(completedEntry);
			if (originPoint) {
				origins.set(`${originPoint.x}:${originPoint.y}`, completedEntry);
			}
			entries.push(completedEntry);
		}

		return { cells, bgTiles, bgPalettes, origins, entries, base };
	}
	function displayOriginPoint(entry) {
		const originX = entry.page * COLS + entry.object.x;
		if (entry.object.y >= 0 && entry.object.y < PLAY_ROWS) {
			return { x: originX, y: entry.object.y };
		}
		const visible = [...entry.footprint]
			.filter((pos) => pos.y >= 0 && pos.y < PLAY_ROWS)
			.sort((a, b) => a.y - b.y || a.x - b.x)[0];
		return visible ? { x: visible.x, y: visible.y } : null;
	}

	function baseFloorInfo() {
		const pattern = clampNumber(state.header.pattern, 0, 15);
		const groundHeight = FLOOR_PATTERN_GROUND_HEIGHT[pattern];
		const ceilingHeight = FLOOR_PATTERN_CEILING_HEIGHT[pattern];
		const middleStart = FLOOR_PATTERN_MIDDLE_START[pattern];
		const middleHeight = FLOOR_PATTERN_MIDDLE_HEIGHT[pattern];
		const floorChar = state.header.floor === 1 ? "H" : state.header.floor === 2 ? "N" : "G";

		return {
			floorChar,
			groundHeight,
			groundStart: Math.max(0, PLAY_ROWS - groundHeight),
			ceilingHeight,
			middleStart,
			middleHeight
		};
	}

	function applyBaseColumn(cells, x, base) {
		for (let y = 0; y < PLAY_ROWS; y += 1) {
			cells[y][x] = { char: "@", tileKey: "@" };
		}

		for (let y = 0; y < base.ceilingHeight && y < PLAY_ROWS; y += 1) {
			cells[y][x] = { char: base.floorChar, tileKey: base.floorChar };
		}

		for (let i = 0; i < base.middleHeight; i += 1) {
			const y = base.middleStart + i;
			if (y >= 0 && y < PLAY_ROWS) {
				cells[y][x] = { char: base.floorChar, tileKey: base.floorChar };
			}
		}

		for (let y = base.groundStart; y < PLAY_ROWS; y += 1) {
			cells[y][x] = { char: base.floorChar, tileKey: base.floorChar };
		}
	}

	function applyObject(cells, object, page, base) {
		const gx = page * COLS + object.x;
		const footprint = [];

		const setCell = (x, y, char, tileKey = char) => {
			if (x < 0 || y < 0 || y >= PLAY_ROWS || x >= cells[0].length) {
				return;
			}
			cells[y][x] = { char, tileKey };
			footprint.push({ x, y });
		};

		const clearGround = (x) => {
			for (let y = base.groundStart; y < PLAY_ROWS; y += 1) {
				cells[y][x] = { char: "@", tileKey: "@" };
				footprint.push({ x, y });
			}
		};

		if (object.y === 12 && object.type === TYPE.HOLE) {
			const width = object.size;
			for (let i = 0; i < width; i += 1) {
				clearGround(gx + i);
			}
			footprint.push({ x: gx, y: 12 });
			return footprint;
		}

		if (object.y === 15 && object.type === TYPE.STAIRS) {
			drawStairs(setCell, gx, object.size + 1, false, base);
			footprint.push({ x: gx, y: 15 });
			return footprint;
		}

		if (object.y === 15 && object.type === TYPE.STAIRS_REV) {
			drawStairs(setCell, gx, object.size + 1, true, base);
			footprint.push({ x: gx, y: 15 });
			return footprint;
		}

		if (object.y === 15 && object.type === TYPE.CASTLE) {
			setCell(gx, 10, "H");
			for (let y = 1; y <= 9; y += 1) {
				setCell(gx, y, "d", "goalPole");
			}
			setCell(gx, 0, "e", "goalBall");
			footprint.push({ x: gx, y: 15 });
			return footprint;
		}

		if (object.y === 15 && object.type === TYPE.BIG_PIPE) {
			drawPipe(setCell, gx, 8, 5);
			footprint.push({ x: gx, y: 15 });
			return footprint;
		}

		if (object.type === TYPE.SINGLE) {
			const block = SINGLE_BLOCKS.find((item) => item.id === object.size) || SINGLE_BLOCKS[4];
			setCell(gx, object.y, block.char);
			return footprint;
		}

		if (object.type === TYPE.BRICK_ROW || object.type === TYPE.HARD_ROW || object.type === TYPE.COIN_ROW) {
			const char = object.type === TYPE.BRICK_ROW ? "B" : object.type === TYPE.HARD_ROW ? "H" : "^";
			const width = sizeOrOne(object.size);
			for (let i = 0; i < width; i += 1) {
				setCell(gx + i, object.y, char);
			}
			return footprint;
		}

		if (object.type === TYPE.BRICK_COLUMN || object.type === TYPE.HARD_COLUMN) {
			const char = object.type === TYPE.BRICK_COLUMN ? "B" : "H";
			const height = sizeOrOne(object.size);
			for (let i = 0; i < height; i += 1) {
				setCell(gx, object.y + i, char);
			}
			return footprint;
		}

		if (object.type === TYPE.PIPE) {
			drawPipe(setCell, gx, object.y, object.size + 2);
			return footprint;
		}

		return footprint;
	}

	function drawStairs(setCell, gx, width, reverse, base) {
		const height = Math.min(width, 8);
		const top = Math.max(0, base.groundStart - height);

		for (let i = 0; i < width; i += 1) {
			const count = reverse ? Math.min(width - i, height) : Math.min(i + 1, height);
			const startY = Math.max(top, base.groundStart - count);
			for (let y = startY; y < base.groundStart; y += 1) {
				setCell(gx + i, y, "H");
			}
		}
	}

	function drawPipe(setCell, gx, topY, height) {
		for (let y = topY; y < topY + height; y += 1) {
			const isTop = y === topY;
			setCell(gx, y, "P", isTop ? "pipeTopLeft" : "pipeLeft");
			setCell(gx + 1, y, "P", isTop ? "pipeTopRight" : "pipeRight");
		}
	}

	function buildBgTileLayer(totalTileCols) {
		const tiles = Array.from({ length: TILE_ROWS }, () => Array.from({ length: totalTileCols }, () => 0));
		const map = BG_MAPS[state.bgScenery];
		if (!map) {
			return tiles;
		}

		const pages = [];
		let page = 0;
		ensureBgTilePage(pages, page);
		for (let i = 0; i < map.length; i += 1) {
			const [posByte, metaByte] = map[i];
			if (i > 0 && (posByte & 0xc0) === 0x80) {
				page += 1;
				ensureBgTilePage(pages, page);
			}

			const x = posByte & 0x1f;
			const yIndex = (metaByte >> 5) & 0x07;
			const objIndex = metaByte & 0x07;
			drawBgObject(pages[page], x, BG_SCENERY_Y_TO_ROW[yIndex] || 0, objIndex);
		}

		for (let x = 0; x < totalTileCols; x += 1) {
			const sourcePage = pages[Math.floor(x / TILE_COLS_PER_PAGE) % pages.length];
			const sourceX = x % TILE_COLS_PER_PAGE;
			for (let y = 0; y < TILE_ROWS; y += 1) {
				tiles[y][x] = sourcePage[y][sourceX] || 0;
			}
		}

		return tiles;
	}

	function ensureBgTilePage(pages, index) {
		while (pages.length <= index) {
			pages.push(Array.from({ length: TILE_ROWS }, () => Array.from({ length: TILE_COLS_PER_PAGE }, () => 0)));
		}
	}

	function buildBgPaletteLayer(totalTileCols) {
		const layer = Array.from({ length: TILE_ROWS }, () => Array.from({ length: totalTileCols }, () => 0));
		const attrPages = buildBgAttributePages(BG_ATTR_MAPS[state.bgScenery]);
		if (attrPages.length === 0) {
			return layer;
		}

		for (let y = 0; y < TILE_ROWS; y += 1) {
			const attrY = Math.floor(y / 4);
			for (let x = 0; x < totalTileCols; x += 1) {
				const page = Math.floor(x / TILE_COLS_PER_PAGE) % attrPages.length;
				const localTileX = x % TILE_COLS_PER_PAGE;
				const attrX = Math.floor(localTileX / 4);
				const attrByte = attrPages[page]?.[attrY]?.[attrX] || 0;
				layer[y][x] = paletteIndexFromAttribute(attrByte, localTileX, y);
			}
		}

		return layer;
	}

	function buildBgAttributePages(records = []) {
		const pages = [];
		let page = 0;
		ensureBgAttributePage(pages, page);

		for (const [posByte, attrByte] of records) {
			if (posByte & 0x80) {
				page += 1;
				ensureBgAttributePage(pages, page);
			}

			const attrX = (posByte >> 4) & 0x07;
			const attrY = (posByte & 0x07) - 1;
			if (attrY < 0 || attrY >= ATTR_ROWS || attrX < 0 || attrX >= ATTR_COLS) {
				continue;
			}

			pages[page][attrY][attrX] = attrByte & 0xff;
		}

		return pages;
	}

	function ensureBgAttributePage(pages, index) {
		while (pages.length <= index) {
			pages.push(Array.from({ length: ATTR_ROWS }, () => Array.from({ length: ATTR_COLS }, () => 0)));
		}
	}

	function paletteIndexFromAttribute(attrByte, localTileX, tileY) {
		const quadrantX = Math.floor((localTileX % 4) / 2);
		const quadrantY = Math.floor((tileY % 4) / 2);
		const shift = (quadrantY * 2 + quadrantX) * 2;
		return (attrByte >> shift) & 0x03;
	}

	function drawBgObject(tiles, baseX, baseY, objIndex) {
		const object = BG_OBJECTS[objIndex];
		if (!object) {
			return;
		}

		for (let localX = 0; localX < object.length; localX += 1) {
			const column = object[localX];
			for (const part of column) {
				const x = baseX + localX;
				const y = baseY - part.dy;
				if (y < 0 || y >= TILE_ROWS || x < 0 || x >= tiles[0].length) {
					continue;
				}
				if (tiles[y][x] === 0) {
					tiles[y][x] = part.tile;
				}
			}
		}
	}

	function tileInfoForCell(cell, quadrant, bgTile, bgPaletteIndex = 0) {
		const char = cell?.char || "@";
		const tileKey = cell?.tileKey || char;
		if (char === "@" && bgTile) {
			return { tile: bgTile, paletteKey: `bg${clampNumber(bgPaletteIndex, 0, 3)}` };
		}

		if (tileKey === "_") {
			return { tile: METATILES._[quadrant], paletteKey: "Q", effect: "hidden", underTile: bgTile, underPaletteKey: `bg${clampNumber(bgPaletteIndex, 0, 3)}` };
		}

		const metatile = METATILES[tileKey] || METATILES[char];
		if (!metatile) {
			return { tile: 0, paletteKey: char };
		}

		const tile = metatile[quadrant];
		if (tileKey === "goalBall" && !tile) {
			return bgTile
				? { tile: bgTile, paletteKey: `bg${clampNumber(bgPaletteIndex, 0, 3)}` }
				: { tile: 0, paletteKey: "bg" };
		}
		return { tile, paletteKey: tileKey };
	}

	function selectedEntry(entries) {
		if (state.selectedId === null) {
			return null;
		}
		return entries.find((entry) => entry.object.id === state.selectedId) || null;
	}

	function currentObjects(pageIndex = state.currentPage) {
		return state.pages[pageIndex].objects;
	}

	function allObjectsWithPage() {
		return state.pages.flatMap((page, pageIndex) =>
			page.objects.map((object) => ({ object, page: pageIndex, footprint: [] }))
		);
	}

	function sortedObjects(entries) {
		return [...entries].sort((a, b) => {
			const ax = a.page * COLS + a.object.x;
			const bx = b.page * COLS + b.object.x;
			if (ax !== bx) {
				return ax - bx;
			}
			return (a.object.order || a.object.id) - (b.object.order || b.object.id);
		});
	}

	function addPage() {
		pushHistory();
		state.pages.splice(state.currentPage + 1, 0, { objects: [] });
		state.currentPage += 1;
		clearSelection();
		setStatus("ページを追加しました。");
		renderAll();
		scrollToCurrentPage();
	}

	function duplicatePage() {
		pushHistory();
		const copy = {
			objects: currentObjects().map((object) => ({
				...object,
				id: nextId++,
				order: nextId
			}))
		};
		state.pages.splice(state.currentPage + 1, 0, copy);
		state.currentPage += 1;
		clearSelection();
		setStatus("ページを複製しました。");
		renderAll();
		scrollToCurrentPage();
	}

	function deletePage() {
		if (state.pages.length <= 1) {
			return;
		}
		pushHistory();
		state.pages.splice(state.currentPage, 1);
		state.currentPage = Math.min(state.currentPage, state.pages.length - 1);
		clearSelection();
		setStatus("ページを削除しました。");
		renderAll();
	}

	function clearCurrentPage() {
		pushHistory();
		currentObjects().length = 0;
		clearSelection();
		setStatus("現在のページを空にしました。");
		renderAll();
	}

	function setCurrentPage(pageIndex) {
		state.currentPage = clampNumber(pageIndex, 0, state.pages.length - 1);
		clearSelection();
		renderAll();
		scrollToCurrentPage();
	}

	function scrollGridBy(direction) {
		const amount = Math.max(240, Math.floor(els.gridWrap.clientWidth * 0.8));
		els.gridWrap.scrollBy({
			left: direction * amount,
			behavior: "smooth"
		});
	}

	function scrollToCurrentPage() {
		window.requestAnimationFrame(() => {
			els.gridWrap.scrollTo({
				left: Math.max(0, state.currentPage * COLS * TILE_CSS_SIZE * 2),
				behavior: "smooth"
			});
		});
	}
	function pageFromTileX(tileX) {
		return clampNumber(Math.floor(tileX / TILE_COLS_PER_PAGE), 0, state.pages.length - 1);
	}

	function localXFromTileX(tileX) {
		return clampNumber(Math.floor((tileX % TILE_COLS_PER_PAGE) / 2), 0, COLS - 1);
	}

	function logicalYFromTileY(tileY) {
		return clampNumber(Math.floor(tileY / 2), 0, PLAY_ROWS - 1);
	}

	async function loadDefaultPalette() {
		try {
			const response = await fetch(new URL("./palette.json", window.location.href), { cache: "no-cache" });
			if (!response.ok) {
				return;
			}
			const data = await response.json();
			if (data.paletteBytes) {
				state.paletteBytes = clonePaletteBytes(data.paletteBytes);
			}
			if (data.rgbColors) {
				state.rgbColors = cloneRgbColors(data.rgbColors);
			}
			rebuildDisplayPalettes();
			syncPaletteControls();
			exportPalettes({ silent: true });
			renderChrPreview();
			renderAll();
		} catch {
			// palette.json is optional; use the built-in defaults when it is absent.
		}
	}

	function syncPaletteControls() {
		if (!els.paletteTargetInput) {
			return;
		}

		if (!PALETTE_KEYS.includes(els.paletteTargetInput.value)) {
			els.paletteTargetInput.value = PALETTE_KEYS[0];
		}

		const key = els.paletteTargetInput.value;
		const palette = state.palettes[key] || state.palettes.palette0;
		const paletteBytes = state.paletteBytes[key] || DEFAULT_PALETTE_BYTES[key];
		for (let index = 0; index < 4; index += 1) {
			const hex = normalizeHexColor(palette[index]) || "#000000";
			const textInput = els[`paletteColor${index}Input`];
			const pickerInput = els[`palettePicker${index}Input`];
			textInput.value = hex;
			textInput.title = `NES color $${toHexByte(paletteBytes[index])}`;
			pickerInput.value = hex;
			pickerInput.title = textInput.title;
			applyPaletteInputStyle(textInput, hex);
			applyPaletteInputStyle(pickerInput, hex);
		}
	}

	function updatePaletteColorFromHex(slot) {
		const hex = normalizeHexColor(els[`paletteColor${slot}Input`].value);
		if (!hex) {
			syncPaletteControls();
			setStatus("Color must be #rrggbb.", true);
			return;
		}
		updateDisplayColor(slot, hex);
	}

	function updatePaletteColorFromPicker(slot) {
		updateDisplayColor(slot, normalizeHexColor(els[`palettePicker${slot}Input`].value) || "#000000");
	}

	function applyPaletteInputStyle(input, hex) {
		input.style.backgroundColor = hex;
		input.style.color = readableTextColor(hex);
	}

	function readableTextColor(hex) {
		const [r, g, b] = hexToRgb(hex);
		return (r * 299 + g * 587 + b * 114) / 1000 >= 140 ? "#111111" : "#ffffff";
	}

	function updateDisplayColor(slot, hex) {
		const key = els.paletteTargetInput.value;
		const palette = state.paletteBytes[key] || DEFAULT_PALETTE_BYTES[key];
		const colorIndex = palette[slot] & 0x3f;
		if (state.rgbColors[colorIndex] === hex) {
			syncPaletteControls();
			return;
		}

		pushHistory();
		state.rgbColors = cloneRgbColors(state.rgbColors);
		state.rgbColors[colorIndex] = hex;
		rebuildDisplayPalettes();
		syncPaletteControls();
		renderChrPreview();
		renderAll();
		setStatus(`Display color for NES color $${toHexByte(colorIndex)} updated.`);
	}

	function exportPalettes(options = {}) {
		syncPaletteText();
		if (options.silent) {
			return;
		}

		const blob = new Blob([flattenPaletteBytes()], { type: "application/octet-stream" });
		const url = URL.createObjectURL(blob);
		const link = document.createElement("a");
		link.href = url;
		link.download = `${sanitizeLabel(state.label || "MAP_CUSTOM")}.pal`;
		document.body.appendChild(link);
		link.click();
		link.remove();
		URL.revokeObjectURL(url);
		setStatus(".pal file exported.");
	}

	function importPalettes() {
		try {
			const bytes = parsePaletteText(els.paletteText.value);
			pushHistory();
			applyPaletteBytes(bytes);
			syncPaletteControls();
			exportPalettes({ silent: true });
			renderChrPreview();
			renderAll();
			setStatus(".pal text imported.");
		} catch {
			setStatus(".pal text could not be imported.", true);
		}
	}

	async function handlePalFileChange(event) {
		const file = event.target.files?.[0];
		if (!file) {
			return;
		}

		try {
			const bytes = new Uint8Array(await file.arrayBuffer());
			pushHistory();
			applyPaletteBytes(bytes);
			syncPaletteControls();
			exportPalettes({ silent: true });
			renderChrPreview();
			renderAll();
			setStatus(`${file.name} imported (${bytes.length} bytes).`);
		} catch {
			setStatus(".pal file could not be imported.", true);
		}
	}

	function resetPalettes() {
		pushHistory();
		state.paletteBytes = clonePaletteBytes();
		state.rgbColors = cloneRgbColors();
		rebuildDisplayPalettes();
		syncPaletteControls();
		exportPalettes({ silent: true });
		renderChrPreview();
		renderAll();
		setStatus("Palette reset to defaults.");
	}

	function clonePalettes(source = null) {
		if (source) {
			const palettes = {};
			for (const key of PALETTE_KEYS) {
				palettes[key] = normalizePalette(source[key], paletteBytesToColors(DEFAULT_PALETTE_BYTES[key], DEFAULT_RGB_COLORS));
			}
			return palettes;
		}
		return paletteBytesToDisplayPalettes(clonePaletteBytes(), cloneRgbColors());
	}

	function rebuildDisplayPalettes() {
		state.palettes = paletteBytesToDisplayPalettes(state.paletteBytes, state.rgbColors);
	}

	function paletteBytesToDisplayPalettes(paletteBytes, rgbColors) {
		const palettes = {};
		for (const key of PALETTE_KEYS) {
			palettes[key] = paletteBytesToColors(paletteBytes[key], rgbColors);
		}
		return palettes;
	}

	function paletteBytesToColors(bytes, rgbColors) {
		const palette = Array.isArray(bytes) ? bytes : DEFAULT_PALETTE_BYTES.palette0;
		return [0, 1, 2, 3].map((index) => rgbColors[(palette[index] || 0) & 0x3f] || "#000000");
	}

	function clonePaletteBytes(source = DEFAULT_PALETTE_BYTES) {
		const paletteBytes = {};
		for (const key of PALETTE_KEYS) {
			const fallback = DEFAULT_PALETTE_BYTES[key];
			const rawPalette = Array.isArray(source[key]) ? source[key] : fallback;
			paletteBytes[key] = [0, 1, 2, 3].map((index) => clampNumber(rawPalette[index] ?? fallback[index], 0, 0x3f));
		}
		syncSharedBgColor(paletteBytes);
		return paletteBytes;
	}

	function syncSharedBgColor(paletteBytes) {
		const bgColor = paletteBytes.palette0?.[0] ?? DEFAULT_PALETTE_BYTES.palette0[0];
		for (const key of PALETTE_KEYS) {
			paletteBytes[key][0] = bgColor;
		}
	}

	function cloneRgbColors(source = DEFAULT_RGB_COLORS) {
		return DEFAULT_RGB_COLORS.map((fallback, index) => normalizeHexColor(source[index]) || fallback);
	}

	function normalizePalette(rawPalette, fallbackPalette) {
		const fallback = fallbackPalette || paletteBytesToColors(DEFAULT_PALETTE_BYTES.palette0, DEFAULT_RGB_COLORS);
		const palette = Array.isArray(rawPalette) ? rawPalette : [];
		return [0, 1, 2, 3].map((index) => normalizePaletteColor(palette[index], fallback[index]));
	}

	function normalizePaletteColor(color, fallback) {
		if (typeof color !== "string") {
			return fallback;
		}

		const normalized = color.trim().toLowerCase();
		if (normalized === "rgba(0,0,0,0)" || /^#[0-9a-f]{6}$/.test(normalized)) {
			return normalized;
		}
		return fallback;
	}

	function flattenPaletteBytes() {
		const bytes = [];
		for (const key of PALETTE_KEYS) {
			bytes.push(...state.paletteBytes[key].map((value) => value & 0x3f));
		}
		return new Uint8Array(bytes);
	}

	function applyPaletteBytes(bytes) {
		if (!bytes || bytes.length < 3) {
			throw new Error("Palette data is empty");
		}

		const next = clonePaletteBytes(state.paletteBytes);
		if (bytes.length % 3 === 0 && bytes.length % 4 !== 0) {
			const rows = Math.min(PALETTE_KEYS.length, Math.floor(bytes.length / 3));
			for (let row = 0; row < rows; row += 1) {
				const key = PALETTE_KEYS[row];
				const offset = row * 3;
				next[key] = [next[key][0], bytes[offset] & 0x3f, bytes[offset + 1] & 0x3f, bytes[offset + 2] & 0x3f];
			}
		} else {
			const rows = Math.min(PALETTE_KEYS.length, Math.floor(bytes.length / 4));
			if (rows === 0) {
				throw new Error("Palette data is too short");
			}
			for (let row = 0; row < rows; row += 1) {
				const key = PALETTE_KEYS[row];
				const offset = row * 4;
				next[key] = [bytes[offset] & 0x3f, bytes[offset + 1] & 0x3f, bytes[offset + 2] & 0x3f, bytes[offset + 3] & 0x3f];
			}
		}

		syncSharedBgColor(next);
		state.paletteBytes = next;
		rebuildDisplayPalettes();
	}

	function syncPaletteText() {
		if (!els.paletteText) {
			return;
		}

		const rows = [];
		for (const key of PALETTE_KEYS) {
			rows.push(`; ${key}`);
			rows.push(`.byte ${state.paletteBytes[key].map((value) => `$${toHexByte(value)}`).join(", ")}`);
		}
		els.paletteText.value = rows.join("\n");
	}

	function parsePaletteText(text) {
		const tokens = text.match(/\$[0-9a-f]{1,2}|0x[0-9a-f]{1,2}|\b[0-9a-f]{2}\b|\b\d{1,3}\b/gi) || [];
		const values = tokens.map((token) => {
			const raw = token.trim().toLowerCase();
			const value = raw.startsWith("$")
				? parseInt(raw.slice(1), 16)
				: raw.startsWith("0x")
					? parseInt(raw.slice(2), 16)
					: /^[0-9a-f]{2}$/.test(raw)
						? parseInt(raw, 16)
						: parseInt(raw, 10);
			if (!Number.isFinite(value) || value < 0 || value > 255) {
				throw new Error("Invalid palette byte");
			}
			return value;
		});
		return new Uint8Array(values);
	}

	function normalizeHexColor(color) {
		if (typeof color !== "string") {
			return null;
		}
		const normalized = color.trim().toLowerCase();
		return /^#[0-9a-f]{6}$/.test(normalized) ? normalized : null;
	}

	function hexToRgb(hex) {
		const normalized = normalizeHexColor(hex) || "#000000";
		const value = parseInt(normalized.slice(1), 16);
		return [(value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff];
	}

	function rgbToHex(rgb) {
		return `#${rgb.map((value) => clampNumber(value, 0, 255).toString(16).padStart(2, "0")).join("")}`;
	}

	function toHexByte(value) {
		return clampNumber(value, 0, 255).toString(16).padStart(2, "0");
	}

	async function fetchDefaultChrResponse() {
		const candidates = ["./spr_bg.chr", "../../spr_bg.chr"];
		for (const candidate of candidates) {
			try {
				const response = await fetch(new URL(candidate, window.location.href), { cache: "no-cache" });
				if (response.ok) {
					return response;
				}
			} catch {
				// Try the next candidate path.
			}
		}
		throw new Error("spr_bg.chr not found");
	}

	async function loadDefaultChr() {
		setChrStatus("spr_bg.chrを読み込み中...");
		try {
			const response = await fetchDefaultChrResponse();
			if (!response.ok) {
				throw new Error(`HTTP ${response.status}`);
			}
			const bytes = new Uint8Array(await response.arrayBuffer());
			loadChrBytes(bytes, "spr_bg.chr");
		} catch {
			setChrStatus("spr_bg.chrを自動読込できませんでした。.chrファイルを選択してください。");
		}
	}

	async function handleChrFileChange(event) {
		const file = event.target.files?.[0];
		if (!file) {
			return;
		}

		try {
			const bytes = new Uint8Array(await file.arrayBuffer());
			loadChrBytes(bytes, file.name);
		} catch {
			setChrStatus("CHRファイルを読み込めませんでした。");
		}
	}

	function loadChrBytes(bytes, label) {
		if (!bytes || bytes.length < 16) {
			setChrStatus("CHRファイルが空、または短すぎます。");
			return;
		}

		chrState.bytes = bytes;
		chrState.loaded = true;
		chrState.bgTileOffset = bytes.length >= 8192 ? BG_PATTERN_TILE_OFFSET : 0;

		renderChrPreview();
		renderAll();
		const tableName = chrState.bgTileOffset === BG_PATTERN_TILE_OFFSET ? "BG $1000" : "BG $0000";
		setChrStatus(`${label}を読み込みました (${bytes.length} bytes)。${tableName}を表示しています。`);
	}

	function renderChrPreview() {
		const canvas = els.chrPreviewCanvas;
		if (!canvas || !chrState.bytes) {
			return;
		}

		const totalTiles = Math.floor(chrState.bytes.length / 16);
		const startTile = Math.min(chrState.bgTileOffset, Math.max(0, totalTiles - 1));
		const tileCount = Math.min(totalTiles - startTile, 256);
		const columns = 16;
		const rows = Math.ceil(tileCount / columns);
		canvas.width = columns * 8;
		canvas.height = rows * 8;
		const ctx = canvas.getContext("2d");
		ctx.clearRect(0, 0, canvas.width, canvas.height);

		for (let tile = 0; tile < tileCount; tile += 1) {
			drawChrTile(ctx, startTile + tile, (tile % columns) * 8, Math.floor(tile / columns) * 8, state.palettes.palette0);
		}
	}

	function bgTileIndex(tileIndex) {
		return chrState.bgTileOffset + tileIndex;
	}

	function drawChrTile(ctx, tileIndex, dx, dy, palette, options = {}) {
		if (!chrState.bytes) {
			return;
		}

		const offset = tileIndex * 16;
		if (offset + 15 >= chrState.bytes.length) {
			return;
		}

		const image = ctx.createImageData(8, 8);
		for (let row = 0; row < 8; row += 1) {
			const low = chrState.bytes[offset + row];
			const high = chrState.bytes[offset + row + 8];
			for (let col = 0; col < 8; col += 1) {
				const bit = 7 - col;
				const colorIndex = ((low >> bit) & 1) | (((high >> bit) & 1) << 1);
				const rgba = parseColor(palette[colorIndex]);
				if (options.grayscale) {
					const gray = Math.round(rgba[0] * 0.299 + rgba[1] * 0.587 + rgba[2] * 0.114);
					rgba[0] = gray;
					rgba[1] = gray;
					rgba[2] = gray;
				}
				if (Number.isFinite(options.alpha)) {
					rgba[3] = Math.round(rgba[3] * options.alpha);
				}
				const pixel = (row * 8 + col) * 4;
				image.data[pixel] = rgba[0];
				image.data[pixel + 1] = rgba[1];
				image.data[pixel + 2] = rgba[2];
				image.data[pixel + 3] = rgba[3];
			}
		}
		ctx.putImageData(image, dx, dy);
	}

	function drawOptionsForTile(tileInfo) {
		return tileInfo?.effect === "hidden"
			? { grayscale: true, alpha: HIDDEN_BLOCK_ALPHA }
			: {};
	}

	function paletteForTileKey(key) {
		const bgMatch = /^bg([0-3])$/.exec(String(key));
		if (bgMatch) {
			return displayPalette(Number(bgMatch[1]));
		}
		if (key === "bg") {
			return displayPalette(0);
		}
		if (key === "G") {
			return displayPalette(0);
		}
		if (key === "B") {
			return displayPalette(0);
		}
		if (key === "H" || key === "N") {
			return displayPalette(0);
		}
		if (key === "Q" || key === "[" || key === "^" || key === "goalBall" || key === "e") {
			return displayPalette(1);
		}
		if (key === "P" || key.startsWith("pipe")) {
			return displayPalette(2);
		}
		if (key === "_" || key === "goalPole" || key === "d") {
			return displayPalette(2);
		}
		return displayPalette(0);
	}

	function displayPalette(index) {
		return state.palettes[`palette${index}`] || state.palettes.palette0;
	}

	function parseColor(color) {
		if (color === "rgba(0,0,0,0)") {
			return [0, 0, 0, 0];
		}

		const hex = color.replace("#", "");
		const value = parseInt(hex, 16);
		return [(value >> 16) & 0xff, (value >> 8) & 0xff, value & 0xff, 0xff];
	}

	function setChrStatus(message) {
		if (els.chrStatus) {
			els.chrStatus.textContent = message;
		}
	}

	function mapBackgroundColor() {
		return state.palettes.palette0?.[0] || FALLBACK_COLORS.bg;
	}

	function fallbackColor(tileInfo, cell) {
		if (tileInfo?.effect === "hidden") {
			return "rgba(128,128,128,0.45)";
		}
		const paletteKey = String(tileInfo.paletteKey || "");
		if (/^bg[0-3]$/.test(paletteKey)) {
			const palette = paletteForTileKey(paletteKey);
			return tileInfo.tile ? (palette[1] || mapBackgroundColor()) : mapBackgroundColor();
		}
		if (tileInfo.paletteKey === "bg" || cell?.char === "@" || !cell) {
			return mapBackgroundColor();
		}
		return FALLBACK_COLORS[cell?.char || "@"] || FALLBACK_COLORS["@"];
	}

	function exportAsm() {
		const label = sanitizeLabel(state.label || "MAP_CUSTOM");
		const lines = [];
		const header = state.header;
		const lastPage = findLastExportPage();
		let insertedMarkers = 0;

		lines.push(`${label}:`);
		lines.push(`\t.byte (SMB_LEVEL_HEADER1 $${toHex(header.timer)}, $${toHex(header.startY)}, $${toHex(header.modifier)})`);
		lines.push(`\t.byte (SMB_LEVEL_HEADER2 $${toHex(header.floor)}, $${toHex(header.scenery)}, $${toHex(header.pattern)})`);
		lines.push("");

		for (let page = 0; page <= lastPage; page += 1) {
			let objects = sortedObjects((state.pages[page]?.objects || []).map((object) => ({ object, page }))).map((entry) => entry.object);

			if (page > 0 && objects.length === 0) {
				insertedMarkers += 1;
				objects = [emptyPageMarker()];
			}

			objects.forEach((object, index) => {
				const macro = page > 0 && index === 0 ? "SMB_OBJ_NEXT" : "SMB_OBJ";
				lines.push(`\t.byte (SMB_OBJ_POS $${toHex(object.x)}, $${toHex(object.y)}), (${macro} ${typeAsm(object)}, ${sizeAsm(object)})\t; ${objectLabel(object)}`);
			});

			if (objects.length > 0) {
				lines.push("");
			}
		}

		lines.push("\t.byte OBJMAP_END");

		if (insertedMarkers > 0) {
			lines.push("");
			lines.push(`; NOTE: ${insertedMarkers} empty page marker(s) were inserted with SMB_SINGLE_SKY.`);
		}

		return lines.join("\n");
	}

	function findLastExportPage() {
		for (let i = state.pages.length - 1; i >= 0; i -= 1) {
			if (state.pages[i].objects.length > 0) {
				return i;
			}
		}
		return 0;
	}

	function emptyPageMarker() {
		return {
			id: -1,
			order: -1,
			x: 0,
			y: 0,
			type: TYPE.SINGLE,
			size: 8
		};
	}

	function typeAsm(object) {
		if (object.y === 12) {
			if (object.type === TYPE.HOLE) {
				return "SMB_SUB2_HOLE";
			}
			if (object.type === 6) {
				return "SMB_SUB2_QBLOCK_ROW";
			}
			if (object.type === 7) {
				return "SMB_SUB2_QBLOCK_POWERUP_ROW";
			}
		}

		if (object.y === 15) {
			if (object.type === TYPE.CASTLE) {
				return "SMB_SUB3_CASTLE";
			}
			if (object.type === TYPE.STAIRS) {
				return "SMB_SUB3_STAIRS";
			}
			if (object.type === TYPE.BIG_PIPE) {
				return "SMB_SUB3_BIG_PIPE";
			}
			if (object.type === TYPE.STAIRS_REV) {
				return "SMB_SUB3_STAIRS_REV";
			}
		}

		return {
			0: "SMB_OBJ_SINGLE",
			1: "SMB_OBJ_PLATFORM",
			2: "SMB_OBJ_BRICK_ROW",
			3: "SMB_OBJ_HARD_ROW",
			4: "SMB_OBJ_COIN_ROW",
			5: "SMB_OBJ_BRICK_COLUMN",
			6: "SMB_OBJ_HARD_COLUMN",
			7: "SMB_OBJ_PIPE"
		}[object.type] || `$${toHex(object.type)}`;
	}

	function sizeAsm(object) {
		if (object.type === TYPE.SINGLE && object.y !== 12 && object.y !== 15) {
			return (SINGLE_BLOCKS.find((item) => item.id === object.size) || SINGLE_BLOCKS[4]).asm;
		}

		if (object.type === TYPE.PIPE && object.y !== 15) {
			return PIPE_SIZE_NAMES[object.size] || `$${toHex(object.size)}`;
		}

		if (object.y === 12 && object.type === TYPE.HOLE) {
			return HOLE_SIZE_NAMES[object.size] || `$${toHex(object.size)}`;
		}

		if (object.y === 15 && (object.type === TYPE.STAIRS || object.type === TYPE.STAIRS_REV)) {
			if (object.size === 3) {
				return object.type === TYPE.STAIRS_REV ? "SMB_STAIRS_4_REVERSE" : "SMB_STAIRS_4";
			}
			if (object.size === 7) {
				return "SMB_STAIRS_8";
			}
		}

		if (object.y === 15 && object.type === TYPE.CASTLE && object.size === 0) {
			return "SMB_CASTLE_SMALL";
		}

		return `$${toHex(object.size)}`;
	}

	function objectLabel(object) {
		if (object.y === 12 && object.type === TYPE.HOLE) {
			return `落とし穴 ${object.size}列`;
		}
		if (object.y === 15 && object.type === TYPE.STAIRS) {
			return `階段 ${object.size + 1}列`;
		}
		if (object.y === 15 && object.type === TYPE.STAIRS_REV) {
			return `逆階段 ${object.size + 1}列`;
		}
		if (object.y === 15 && object.type === TYPE.CASTLE) {
			return "ゴール/城";
		}
		if (object.y === 15 && object.type === TYPE.BIG_PIPE) {
			return "巨大土管";
		}
		if (object.type === TYPE.SINGLE) {
			const block = SINGLE_BLOCKS.find((item) => item.id === object.size);
			return block ? `単体 ${block.label}` : "単体";
		}
		if (object.type === TYPE.BRICK_ROW) {
			return `レンガ横列 ${sizeOrOne(object.size)}列`;
		}
		if (object.type === TYPE.HARD_ROW) {
			return `固いブロック横列 ${sizeOrOne(object.size)}列`;
		}
		if (object.type === TYPE.COIN_ROW) {
			return `コイン横列 ${sizeOrOne(object.size)}列`;
		}
		if (object.type === TYPE.BRICK_COLUMN) {
			return `レンガ縦列 ${sizeOrOne(object.size)}行`;
		}
		if (object.type === TYPE.HARD_COLUMN) {
			return `固いブロック縦列 ${sizeOrOne(object.size)}行`;
		}
		if (object.type === TYPE.PIPE) {
			return `土管 ${object.size + 2}行`;
		}
		return `type $${toHex(object.type)}`;
	}

	function markerGlyph(object) {
		if (object.y === 12 && object.type === TYPE.HOLE) {
			return "穴";
		}
		if (object.y === 15 && object.type === TYPE.STAIRS) {
			return "階";
		}
		if (object.y === 15 && object.type === TYPE.STAIRS_REV) {
			return "逆";
		}
		if (object.y === 15 && object.type === TYPE.CASTLE) {
			return "城";
		}
		if (object.y === 15 && object.type === TYPE.BIG_PIPE) {
			return "管";
		}
		return "M";
	}

	function importAsm() {
		try {
			const parsed = parseAsm(els.asmInput.value);
			if (!parsed.pages.some((page) => page.objects.length > 0)) {
				setStatus("読み込めるオブジェクトが見つかりませんでした。", true);
				return;
			}

			pushHistory();
			state.label = parsed.label || state.label;
			state.header = parsed.header;
			state.pages = parsed.pages;
			state.currentPage = firstPageWithObjects(parsed.pages);
			clearSelection();
			nextId = Math.max(parsed.nextId, maxObjectId() + 1);
			syncControlsFromState();
			setStatus("ASMを読み込みました。");
			renderAll();
			scrollToCurrentPage();
		} catch (error) {
			setStatus(error.message, true);
		}
	}

	function firstPageWithObjects(pages) {
		const index = pages.findIndex((page) => Array.isArray(page.objects) && page.objects.length > 0);
		return index === -1 ? 0 : index;
	}

	function selectAsmMapSource(source) {
		const targets = mapArrayTargets(source);
		if (targets.length === 0) {
			return { source, label: "" };
		}

		const block = labelBlockSource(source, targets[0]);
		return block ? { source: block, label: targets[0] } : { source, label: targets[0] };
	}

	function mapArrayTargets(source) {
		const targets = [];
		let inMapArray = false;
		for (const rawLine of source.split(/\r?\n/)) {
			const clean = rawLine.replace(/;.*/, "").trim();
			if (!clean) {
				continue;
			}
			const labelMatch = clean.match(/^([A-Za-z_][A-Za-z0-9_]*):$/);
			if (labelMatch) {
				if (/^MAP_ARR/i.test(labelMatch[1])) {
					inMapArray = true;
					continue;
				}
				if (inMapArray) {
					break;
				}
			}
			if (!inMapArray) {
				continue;
			}
			const addrMatch = clean.match(/^\.addr\s+(.+)/i);
			if (!addrMatch) {
				continue;
			}
			for (const token of addrMatch[1].split(",").map((item) => item.trim())) {
				if (/^\$?ffff$/i.test(token)) {
					return targets;
				}
				if (/^[A-Za-z_][A-Za-z0-9_]*$/.test(token)) {
					targets.push(token);
				}
			}
		}
		return targets;
	}

	function labelBlockSource(source, label) {
		const lines = source.split(/\r?\n/);
		const labelPattern = new RegExp("^\\s*" + escapeRegExp(label) + ":\\s*(?:;.*)?$");
		const start = lines.findIndex((line) => labelPattern.test(line));
		if (start === -1) {
			return "";
		}
		let end = lines.length;
		for (let index = start + 1; index < lines.length; index += 1) {
			if (/^[A-Za-z_][A-Za-z0-9_]*:\s*(?:;.*)?$/.test(lines[index].trim())) {
				end = index;
				break;
			}
		}
		return lines.slice(start, end).join("\n");
	}

	function escapeRegExp(value) {
		return String(value).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
	}

	function parseAsm(source) {
		const selectedMap = selectAsmMapSource(source);
		source = selectedMap.source;
		const lines = source.split(/\r?\n/);
		const parsed = {
			label: selectedMap.label || "",
			header: { ...state.header },
			pages: [{ objects: [] }],
			nextId
		};
		let currentPage = 0;
		let sawData = false;
		let parsedNextId = nextId;

		for (const line of lines) {
			const clean = line.replace(/;.*/, "").trim();
			if (!clean) {
				continue;
			}

			const labelMatch = clean.match(/^([A-Za-z_][A-Za-z0-9_]*):$/);
			if (labelMatch) {
				if (!parsed.label) {
					parsed.label = labelMatch[1];
				}
				continue;
			}

			const h1 = clean.match(/SMB_LEVEL_HEADER1\s+([^,\)]+),\s*([^,\)]+),\s*([^\)]+)/);
			if (h1) {
				parsed.header.timer = parseValue(h1[1]);
				parsed.header.startY = parseValue(h1[2]);
				parsed.header.modifier = parseValue(h1[3]);
				sawData = true;
				continue;
			}

			const h2 = clean.match(/SMB_LEVEL_HEADER2\s+([^,\)]+),\s*([^,\)]+),\s*([^\)]+)/);
			if (h2) {
				parsed.header.floor = parseValue(h2[1]);
				parsed.header.scenery = parseValue(h2[2]);
				parsed.header.pattern = parseValue(h2[3]);
				sawData = true;
				continue;
			}

			if (/OBJMAP_END/.test(clean)) {
				if (sawData) {
					break;
				}
				continue;
			}

			const objectMatch = clean.match(/\.byte\s+\(SMB_OBJ_POS\s+([^,\)]+),\s*([^\)]+)\)\s*,\s*\((SMB_OBJ_NEXT|SMB_OBJ)\s+([^,\)]+),\s*([^\)]+)\)/);
			if (!objectMatch) {
				continue;
			}

			if (objectMatch[3] === "SMB_OBJ_NEXT") {
				currentPage += 1;
			}

			ensureParsedPage(parsed.pages, currentPage);
			parsed.pages[currentPage].objects.push({
				id: parsedNextId++,
				order: parsedNextId,
				x: clampNumber(parseValue(objectMatch[1]), 0, 15),
				y: clampNumber(parseValue(objectMatch[2]), 0, 15),
				type: clampNumber(parseValue(objectMatch[4]), 0, 15),
				size: clampNumber(parseValue(objectMatch[5]), 0, 15)
			});
			sawData = true;
		}

		parsed.header.timer = clampNumber(parsed.header.timer, 0, 3);
		parsed.header.startY = clampNumber(parsed.header.startY, 0, 7);
		parsed.header.modifier = clampNumber(parsed.header.modifier, 0, 7);
		parsed.header.floor = clampNumber(parsed.header.floor, 0, 3);
		parsed.header.scenery = clampNumber(parsed.header.scenery, 0, 3);
		parsed.header.pattern = clampNumber(parsed.header.pattern, 0, 15);
		parsed.nextId = parsedNextId;
		return parsed;
	}
	function parseValue(raw) {
		const token = raw.trim().replace(/[()]/g, "");
		if (Object.prototype.hasOwnProperty.call(CONSTANTS, token)) {
			return CONSTANTS[token];
		}
		if (/^\$[0-9a-f]+$/i.test(token)) {
			return parseInt(token.slice(1), 16);
		}
		if (/^%[01_]+$/i.test(token)) {
			return parseInt(token.slice(1).replace(/_/g, ""), 2);
		}
		if (/^\d+$/.test(token)) {
			return parseInt(token, 10);
		}
		throw new Error(`値を解釈できません: ${raw}`);
	}

	function ensureParsedPage(pages, index) {
		while (pages.length <= index) {
			pages.push({ objects: [] });
		}
	}

	function syncControlsFromState() {
		els.mapLabelInput.value = state.label;
		els.timerInput.value = state.header.timer;
		els.startYInput.value = state.header.startY;
		els.modifierInput.value = state.header.modifier;
		els.floorInput.value = state.header.floor;
		els.sceneryInput.value = state.header.scenery;
		els.patternInput.value = state.header.pattern;
		els.bgSceneryInput.value = state.bgScenery;
		syncPaletteControls();
	}

	function resetMap() {
		pushHistory();
		state.label = "MAP_CUSTOM";
		state.header = { timer: 0, startY: 5, modifier: 0, floor: 0, scenery: 0, pattern: 1 };
		state.bgScenery = 0;
		state.pages = [{ objects: [] }];
		state.currentPage = 0;
		clearSelection();
		syncControlsFromState();
		setStatus("新規マップにしました。");
		renderAll();
	}

	function saveLocal() {
		const data = {
			label: state.label,
			header: state.header,
			bgScenery: state.bgScenery,
			pages: state.pages,
			currentPage: state.currentPage,
			paletteBytes: state.paletteBytes,
			rgbColors: state.rgbColors,
			nextId
		};
		localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
		setStatus("ブラウザに保存しました。");
	}

	function loadLocal() {
		const raw = localStorage.getItem(STORAGE_KEY);
		if (!raw) {
			setStatus("保存データがありません。", true);
			return;
		}

		try {
			const data = JSON.parse(raw);
			pushHistory();
			state.label = sanitizeLabel(data.label || "MAP_CUSTOM");
			state.header = { ...state.header, ...data.header };
			state.bgScenery = clampNumber(data.bgScenery ?? state.bgScenery, -1, 1);
			state.pages = Array.isArray(data.pages) && data.pages.length > 0 ? data.pages : [{ objects: [] }];
			state.paletteBytes = clonePaletteBytes(data.paletteBytes || state.paletteBytes);
			state.rgbColors = cloneRgbColors(data.rgbColors || state.rgbColors);
			rebuildDisplayPalettes();
			state.currentPage = clampNumber(data.currentPage || 0, 0, state.pages.length - 1);
			clearSelection();
			nextId = Math.max(Number(data.nextId) || 1, maxObjectId() + 1);
			syncControlsFromState();
			exportPalettes({ silent: true });
			setStatus("保存データを読み込みました。");
			renderAll();
		} catch {
			setStatus("保存データの形式が壊れています。", true);
		}
	}

	async function copyOutput() {
		const text = els.asmOutput.value;
		try {
			await navigator.clipboard.writeText(text);
			setStatus("ASM出力をコピーしました。");
		} catch {
			els.asmOutput.focus();
			els.asmOutput.select();
			setStatus("コピーできないため、出力欄を選択しました。");
		}
	}

	function downloadOutput() {
		const blob = new Blob([els.asmOutput.value], { type: "text/plain;charset=utf-8" });
		const url = URL.createObjectURL(blob);
		const link = document.createElement("a");
		link.href = url;
		link.download = `${sanitizeLabel(state.label || "MAP_CUSTOM")}.inc`;
		document.body.appendChild(link);
		link.click();
		link.remove();
		URL.revokeObjectURL(url);
		setStatus("ASM出力を保存しました。");
	}

	function maxObjectId() {
		return state.pages.reduce((max, page) => {
			return Math.max(max, ...page.objects.map((object) => object.id || 0));
		}, 0);
	}

	function createSnapshot() {
		return {
			label: state.label,
			header: { ...state.header },
			bgScenery: state.bgScenery,
			pages: state.pages.map((page) => ({
				objects: page.objects.map((object) => ({ ...object }))
			})),
			currentPage: state.currentPage,
			selectedId: state.selectedId,
			selectedIds: selectionIds(),
			paletteBytes: clonePaletteBytes(state.paletteBytes),
			rgbColors: cloneRgbColors(state.rgbColors),
			nextId
		};
	}

	function restoreSnapshot(snapshot) {
		state.label = snapshot.label;
		state.header = { ...snapshot.header };
		state.bgScenery = clampNumber(snapshot.bgScenery ?? 0, -1, 1);
		state.pages = snapshot.pages.map((page) => ({
			objects: page.objects.map((object) => ({ ...object }))
		}));
		state.currentPage = clampNumber(snapshot.currentPage, 0, state.pages.length - 1);
		setSelectedIds(snapshot.selectedIds || (snapshot.selectedId === null ? [] : [snapshot.selectedId]));
		state.paletteBytes = clonePaletteBytes(snapshot.paletteBytes || state.paletteBytes);
		state.rgbColors = cloneRgbColors(snapshot.rgbColors || state.rgbColors);
		rebuildDisplayPalettes();
		nextId = snapshot.nextId;
		syncControlsFromState();
		exportPalettes({ silent: true });
		renderAll();
	}

	function pushHistory({ clearRedo = true } = {}) {
		undoStack.push(createSnapshot());
		if (undoStack.length > HISTORY_LIMIT) {
			undoStack.shift();
		}
		if (clearRedo) {
			redoStack.length = 0;
		}
		updateUndoButton();
	}

	function undoLast() {
		const snapshot = undoStack.pop();
		if (!snapshot) {
			setStatus("戻せる操作がありません。", true);
			updateUndoButton();
			return;
		}

		redoStack.push(createSnapshot());
		restoreSnapshot(snapshot);
		setStatus("1つ前の状態に戻しました。");
		updateUndoButton();
	}

	function redoLast() {
		const snapshot = redoStack.pop();
		if (!snapshot) {
			setStatus("進める操作がありません。", true);
			updateUndoButton();
			return;
		}

		pushHistory({ clearRedo: false });
		restoreSnapshot(snapshot);
		setStatus("1つ先の状態に進めました。");
		updateUndoButton();
	}

	function updateUndoButton() {
		if (els.undoButton) {
			els.undoButton.disabled = undoStack.length === 0;
		}
		if (els.redoButton) {
			els.redoButton.disabled = redoStack.length === 0;
		}
	}

	function setStatus(message, isError = false) {
		els.statusText.textContent = message;
		els.statusText.classList.toggle("error", isError);
	}

	function sanitizeLabel(label) {
		const safe = String(label || "").trim().replace(/[^\w]/g, "_");
		return safe || "MAP_CUSTOM";
	}

	function sizeOrOne(value) {
		return value === 0 ? 1 : value;
	}

	function clampNumber(value, min, max) {
		const number = Number.parseInt(value, 10);
		if (Number.isNaN(number)) {
			return min;
		}
		return Math.min(max, Math.max(min, number));
	}

	function toHex(value) {
		return clampNumber(value, 0, 255).toString(16);
	}

	function escapeHtml(value) {
		return String(value)
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;");
	}
})();
