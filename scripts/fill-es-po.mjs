import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const esPoPath = join(__dirname, "../priv/gettext/es/LC_MESSAGES/default.po");
const enPoPath = join(__dirname, "../priv/gettext/en/LC_MESSAGES/default.po");

const es = {
  "%{hours}h to reach 8h": "%{hours}h para alcanzar 8h",
  Acknowledged: "Reconocido",
  Activity: "Actividad",
  "Add a project line to log hours for this day.": "Añade una línea de proyecto para registrar horas en este día.",
  "Add entry": "Añadir entrada",
  "Add time entry": "Añadir imputación",
  "Apply template %{name}": "Aplicar plantilla %{name}",
  Approved: "Aprobado",
  "Awaiting acknowledgement": "Pendiente de reconocimiento",
  "Bottom navigation": "Navegación inferior",
  "Briefing on %{date}": "Briefing del %{date}",
  "Calendar status legend": "Leyenda de estados del calendario",
  Cancel: "Cancelar",
  "Change language": "Cambiar idioma",
  "Toggle language": "Cambiar idioma",
  Clear: "Borrar",
  Close: "Cerrar",
  "Close day editor": "Cerrar editor del día",
  "Close panel": "Cerrar panel",
  "Close templates panel": "Cerrar panel de plantillas",
  Complete: "Completo",
  "Created by %{name}": "Creado por %{name}",
  "Daily goal reached": "Objetivo diario alcanzado",
  Day: "Día",
  "Delegated by": "Delegado por",
  Delete: "Eliminar",
  Draft: "Borrador",
  "Draft · only visible to you": "Borrador · solo visible para ti",
  "Edit entry": "Editar entrada",
  "Edit time entry": "Editar imputación",
  English: "Inglés",
  Evaluator: "Evaluador",
  "Evaluated by %{name}": "Evaluado por %{name}",
  Holiday: "Festivo",
  Hours: "Horas",
  "Include inactive projects": "Incluir proyectos inactivos",
  "Logged hours": "Horas registradas",
  "New": "Nuevo",
  "No entries yet": "Sin entradas aún",
  "No projects match your search.": "Ningún proyecto coincide con tu búsqueda.",
  "No reported hours for this scope.": "Sin horas reportadas en este ámbito.",
  "No reported hours in this period for this person.": "Sin horas reportadas en este periodo para esta persona.",
  "Non-working": "No laborable",
  Objectives: "Objetivos",
  "Objectives and evaluator assessment": "Objetivos y evaluación del evaluador",
  "Open day": "Abrir día",
  "Open menu": "Abrir menú",
  "Overall assessment": "Evaluación global",
  Progress: "Progreso",
  Project: "Proyecto",
  "Recommended structure": "Estructura recomendada",
  Rejected: "Rechazado",
  "Remove this time entry?": "¿Eliminar esta imputación?",
  "Reported hours": "Horas reportadas",
  "Save draft": "Guardar borrador",
  "Search or type a project": "Buscar o escribir un proyecto",
  "Search projects…": "Buscar proyectos…",
  "Searching…": "Buscando…",
  "Segmented control": "Control segmentado",
  Selected: "Seleccionado",
  Sent: "Enviado",
  "Show %{count} more clients": "Mostrar %{count} clientes más",
  "Show fewer clients": "Mostrar menos clientes",
  Spanish: "Español",
  Strengths: "Fortalezas",
  "Strengths, weaknesses, recommendations": "Fortalezas, debilidades y recomendaciones",
  Templates: "Plantillas",
  "This day cannot be edited.": "Este día no se puede editar.",
  "Toggle branch": "Alternar rama",
  "Toggle theme": "Cambiar tema",
  Type: "Tipo",
  "Update entry": "Actualizar entrada",
  User: "Usuario",
  Vacation: "Vacaciones",
  Weaknesses: "Debilidades",
  Recommendations: "Recomendaciones",
  Home: "Inicio",
  Foundations: "Fundamentos",
  Layout: "Layout",
  Components: "Componentes",
  Forms: "Formularios",
  Feedback: "Feedback",
  "Get started": "Comenzar",
  Buttons: "Botones",
  "Fields / Inputs": "Campos / Entradas",
  "Common buttons": "Botones habituales",
};

function fillPo(path, translate) {
  let po = readFileSync(path, "utf8");
  po = po.replace(/^msgid "(.*)"\nmsgstr ""$/gm, (_, msgid) => {
    const unescaped = msgid.replace(/\\"/g, '"').replace(/\\\\/g, "\\");
    const msgstr = translate(unescaped);
    const esc = (s) => s.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
    return `msgid "${esc(unescaped)}"\nmsgstr "${esc(msgstr)}"`;
  });
  writeFileSync(path, po);
  console.log(`Updated ${path}`);
}

fillPo(esPoPath, (msgid) => es[msgid] ?? msgid);
fillPo(enPoPath, (msgid) => msgid);
