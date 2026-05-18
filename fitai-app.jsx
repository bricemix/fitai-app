import { useState, useRef, useEffect, useCallback } from "react";

// ─── Palette & design tokens ────────────────────────────────────────────────
const css = `
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Syne:wght@700;800&display=swap');

  :root {
    --bg: #0a0a0f;
    --surface: #12121a;
    --surface2: #1a1a28;
    --border: #ffffff12;
    --accent: #c8ff5a;
    --accent2: #5af0ff;
    --accent3: #ff5a9d;
    --text: #f0f0f8;
    --muted: #7070a0;
    --radius: 20px;
    --font-head: 'Syne', sans-serif;
    --font-body: 'Space Grotesk', sans-serif;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: var(--font-body); }

  .app { max-width: 430px; min-height: 100dvh; margin: 0 auto; background: var(--bg); position: relative; overflow: hidden; display: flex; flex-direction: column; }

  /* ── nav ── */
  .nav { display: flex; justify-content: space-around; padding: 12px 8px 24px; background: var(--surface); border-top: 1px solid var(--border); position: sticky; bottom: 0; z-index: 99; }
  .nav-btn { display: flex; flex-direction: column; align-items: center; gap: 4px; font-size: 10px; color: var(--muted); background: none; border: none; cursor: pointer; transition: color .2s; padding: 6px 12px; border-radius: 12px; }
  .nav-btn.active { color: var(--accent); background: var(--accent)18; }
  .nav-btn svg { width: 22px; height: 22px; }

  /* ── page scroll area ── */
  .page { flex: 1; overflow-y: auto; padding: 20px 16px 0; scroll-behavior: smooth; }
  .page::-webkit-scrollbar { display: none; }

  /* ── headers ── */
  .page-title { font-family: var(--font-head); font-size: 28px; font-weight: 800; letter-spacing: -1px; margin-bottom: 6px; }
  .page-sub { color: var(--muted); font-size: 13px; margin-bottom: 20px; }

  /* ── cards ── */
  .card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 18px; margin-bottom: 14px; }
  .card-sm { background: var(--surface2); border-radius: 14px; padding: 14px; }

  /* ── accent pill ── */
  .pill { display: inline-flex; align-items: center; gap: 6px; background: var(--accent)18; color: var(--accent); border-radius: 100px; padding: 4px 12px; font-size: 12px; font-weight: 600; }

  /* ── ring progress ── */
  .ring-wrap { display: flex; align-items: center; gap: 16px; }
  .ring svg { transform: rotate(-90deg); }
  .ring-label { font-family: var(--font-head); font-size: 36px; font-weight: 800; line-height: 1; }
  .ring-sub { color: var(--muted); font-size: 12px; margin-top: 2px; }

  /* ── macro bars ── */
  .macro-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 14px; }
  .macro-item { background: var(--surface2); border-radius: 14px; padding: 12px; text-align: center; }
  .macro-value { font-family: var(--font-head); font-size: 20px; font-weight: 800; }
  .macro-name { font-size: 11px; color: var(--muted); margin-top: 2px; }
  .bar-bg { background: var(--surface); border-radius: 100px; height: 5px; margin-top: 8px; overflow: hidden; }
  .bar-fill { height: 100%; border-radius: 100px; transition: width .6s cubic-bezier(.4,0,.2,1); }

  /* ── food photo area ── */
  .photo-drop { border: 2px dashed var(--accent)50; border-radius: var(--radius); padding: 32px 20px; text-align: center; cursor: pointer; transition: all .2s; position: relative; overflow: hidden; }
  .photo-drop:hover { border-color: var(--accent); background: var(--accent)08; }
  .photo-drop img { width: 100%; border-radius: 14px; max-height: 240px; object-fit: cover; }
  .photo-icon { font-size: 48px; margin-bottom: 10px; }
  .photo-hint { color: var(--muted); font-size: 13px; }
  input[type=file] { display: none; }

  /* ── analyzing overlay ── */
  .analyzing { display: flex; flex-direction: column; align-items: center; gap: 12px; padding: 24px; }
  .spinner { width: 48px; height: 48px; border: 3px solid var(--accent)30; border-top-color: var(--accent); border-radius: 50%; animation: spin .8s linear infinite; }
  @keyframes spin { to { transform: rotate(360deg); } }
  .pulse-text { animation: pulse 1.4s ease-in-out infinite; }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.4} }

  /* ── nutrient result ── */
  .nutrient-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 14px; }
  .nutrient-tile { background: var(--surface2); border-radius: 14px; padding: 12px 14px; }
  .nutrient-val { font-size: 22px; font-weight: 700; font-family: var(--font-head); }
  .nutrient-unit { font-size: 11px; color: var(--muted); }

  /* ── form inputs ── */
  .input-group { margin-bottom: 14px; }
  label { font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: .5px; margin-bottom: 6px; display: block; }
  input, select, textarea { width: 100%; background: var(--surface2); border: 1px solid var(--border); border-radius: 12px; padding: 12px 14px; color: var(--text); font-family: var(--font-body); font-size: 14px; outline: none; transition: border-color .2s; }
  input:focus, select:focus { border-color: var(--accent)80; }
  select option { background: var(--surface); }
  textarea { resize: none; height: 80px; }

  /* ── buttons ── */
  .btn { width: 100%; padding: 14px; border-radius: 14px; font-family: var(--font-head); font-size: 15px; font-weight: 700; border: none; cursor: pointer; transition: all .2s; }
  .btn-primary { background: var(--accent); color: #0a0a0f; }
  .btn-primary:hover { filter: brightness(1.1); transform: translateY(-1px); }
  .btn-secondary { background: var(--surface2); color: var(--text); border: 1px solid var(--border); }
  .btn-sm { width: auto; padding: 8px 16px; font-size: 13px; border-radius: 10px; }

  /* ── timeline ── */
  .timeline-item { display: flex; align-items: flex-start; gap: 14px; padding: 12px 0; border-bottom: 1px solid var(--border); }
  .timeline-dot { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 16px; flex-shrink: 0; }
  .timeline-content h4 { font-size: 14px; font-weight: 600; }
  .timeline-content p { font-size: 12px; color: var(--muted); margin-top: 2px; }

  /* ── progress chart ── */
  .chart-row { display: flex; align-items: flex-end; gap: 6px; height: 80px; }
  .chart-bar-wrap { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 4px; }
  .chart-bar { width: 100%; border-radius: 6px 6px 0 0; background: var(--accent)40; transition: height .4s; position: relative; }
  .chart-bar.today { background: var(--accent); }
  .chart-day { font-size: 10px; color: var(--muted); }

  /* ── ai chat ── */
  .chat-bubble { padding: 12px 16px; border-radius: 16px; max-width: 85%; font-size: 14px; line-height: 1.5; margin-bottom: 10px; }
  .chat-bubble.user { background: var(--accent); color: #0a0a0f; margin-left: auto; border-bottom-right-radius: 4px; }
  .chat-bubble.ai { background: var(--surface2); border-bottom-left-radius: 4px; }
  .chat-input-row { display: flex; gap: 10px; padding: 12px 0; position: sticky; bottom: 0; background: var(--bg); }
  .chat-input-row input { flex: 1; }
  .send-btn { background: var(--accent); border: none; border-radius: 12px; padding: 0 16px; color: #0a0a0f; font-size: 20px; cursor: pointer; }

  /* ── badges ── */
  .badge { display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 50%; background: var(--accent3); color: #fff; font-size: 10px; font-weight: 700; }

  /* ── meal log entry ── */
  .meal-entry { display: flex; align-items: center; gap: 12px; padding: 10px 0; border-bottom: 1px solid var(--border); }
  .meal-thumb { width: 50px; height: 50px; border-radius: 12px; object-fit: cover; background: var(--surface2); display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
  .meal-info { flex: 1; }
  .meal-info h4 { font-size: 14px; font-weight: 600; }
  .meal-info p { font-size: 12px; color: var(--muted); }
  .meal-kcal { font-family: var(--font-head); font-size: 16px; font-weight: 700; color: var(--accent); }

  /* ── step wizard ── */
  .wizard-steps { display: flex; gap: 8px; margin-bottom: 24px; }
  .wizard-step { flex: 1; height: 4px; border-radius: 2px; background: var(--surface2); transition: background .3s; }
  .wizard-step.done { background: var(--accent); }

  /* ── toast ── */
  .toast { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); background: var(--accent); color: #0a0a0f; padding: 10px 20px; border-radius: 100px; font-weight: 700; font-size: 13px; z-index: 9999; animation: slideDown .3s ease; }
  @keyframes slideDown { from { top: -40px; opacity: 0; } to { top: 20px; opacity: 1; } }

  /* ── onboarding hero ── */
  .hero-bg { background: radial-gradient(ellipse at 50% 0%, var(--accent)20 0%, transparent 70%); padding: 40px 20px 20px; text-align: center; }
  .hero-emoji { font-size: 72px; margin-bottom: 16px; }
  .hero-title { font-family: var(--font-head); font-size: 36px; font-weight: 800; line-height: 1.1; letter-spacing: -1px; }
  .hero-title span { color: var(--accent); }
  .hero-sub { color: var(--muted); font-size: 15px; margin-top: 10px; line-height: 1.5; }

  .tags { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }
  .tag { background: var(--surface2); border: 1px solid var(--border); border-radius: 100px; padding: 6px 14px; font-size: 12px; cursor: pointer; transition: all .2s; }
  .tag.sel { background: var(--accent); color: #0a0a0f; border-color: var(--accent); font-weight: 600; }
`;

// ─── Mock AI analysis via Anthropic API ────────────────────────────────────
async function analyzeFood(base64Image) {
  try {
    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "claude-sonnet-4-20250514",
        max_tokens: 800,
        messages: [{
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: "image/jpeg", data: base64Image } },
            { type: "text", text: `Analyse this food photo and return ONLY a JSON object (no markdown, no explanation) with these keys:
{
  "name": "food name in French",
  "calories": number (kcal for this portion),
  "protein": number (grams),
  "carbs": number (grams),
  "fat": number (grams),
  "fiber": number (grams),
  "vitamins": "brief key vitamins",
  "minerals": "brief key minerals",
  "healthScore": number (1-10),
  "tip": "short nutrition tip in French (1 sentence)"
}` }
          ]
        }]
      })
    });
    const data = await response.json();
    const text = data.content?.find(b => b.type === "text")?.text || "{}";
    return JSON.parse(text.replace(/```json|```/g, "").trim());
  } catch {
    return null;
  }
}

async function askNutritionAI(messages, profile) {
  try {
    const systemPrompt = `Tu es FitAI, un coach nutrition et fitness expert. 
Profil utilisateur: ${JSON.stringify(profile)}
Tu réponds en français, de façon concise et pratique. Max 3-4 phrases.`;

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "claude-sonnet-4-20250514",
        max_tokens: 400,
        system: systemPrompt,
        messages: messages.filter(m => m.role !== "system")
      })
    });
    const data = await response.json();
    return data.content?.find(b => b.type === "text")?.text || "Désolé, je n'ai pas pu répondre.";
  } catch {
    return "Mode hors ligne - connexion requise pour l'IA.";
  }
}

// ─── Storage helpers ────────────────────────────────────────────────────────
const store = {
  get: k => { try { return JSON.parse(localStorage.getItem("fitai_" + k)) } catch { return null } },
  set: (k, v) => localStorage.setItem("fitai_" + k, JSON.stringify(v))
};

// ─── Icons ──────────────────────────────────────────────────────────────────
const Icons = {
  Home: () => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9,22 9,12 15,12 15,22"/></svg>,
  Camera: () => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>,
  Chat: () => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>,
  Chart: () => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}><polyline points="22,12 18,12 15,21 9,3 6,12 2,12"/></svg>,
  User: () => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2}><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>,
};

// ─── Onboarding Wizard ───────────────────────────────────────────────────────
function Onboarding({ onDone }) {
  const [step, setStep] = useState(0);
  const [form, setForm] = useState({ name: "", age: "", gender: "homme", weight: "", height: "", goal: "", activity: "modéré", restrictions: [] });

  const goals = ["Perdre du poids", "Prendre de la masse", "Maintenir", "Améliorer l'endurance", "Manger sainement"];
  const restrictions = ["Végétarien", "Vegan", "Sans gluten", "Sans lactose", "Halal", "Keto"];
  const activities = ["Sédentaire", "Léger (1-2j/sem)", "Modéré (3-4j/sem)", "Actif (5-6j/sem)", "Très actif"];

  const up = (k, v) => setForm(f => ({ ...f, [k]: v }));
  const toggleR = r => setForm(f => ({ ...f, restrictions: f.restrictions.includes(r) ? f.restrictions.filter(x => x !== r) : [...f.restrictions, r] }));

  const steps = [
    // 0 - Welcome
    <div className="hero-bg">
      <div className="hero-emoji">🏋️</div>
      <h1 className="hero-title">Bienvenue sur <span>FitAI</span></h1>
      <p className="hero-sub">Votre coach nutrition & fitness alimenté par l'IA. Analysez vos repas en photo, suivez vos macros et atteignez vos objectifs.</p>
      <div style={{ marginTop: 32, padding: "0 20px" }}>
        <button className="btn btn-primary" onClick={() => setStep(1)}>Commencer →</button>
      </div>
    </div>,

    // 1 - Identity
    <div>
      <div className="input-group"><label>Votre prénom</label><input placeholder="Ex: Marie" value={form.name} onChange={e => up("name", e.target.value)} /></div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <div className="input-group"><label>Âge</label><input type="number" placeholder="25" value={form.age} onChange={e => up("age", e.target.value)} /></div>
        <div className="input-group"><label>Genre</label><select value={form.gender} onChange={e => up("gender", e.target.value)}><option>homme</option><option>femme</option><option>autre</option></select></div>
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <div className="input-group"><label>Poids (kg)</label><input type="number" placeholder="70" value={form.weight} onChange={e => up("weight", e.target.value)} /></div>
        <div className="input-group"><label>Taille (cm)</label><input type="number" placeholder="175" value={form.height} onChange={e => up("height", e.target.value)} /></div>
      </div>
    </div>,

    // 2 - Goal
    <div>
      <p className="page-sub">Quel est votre objectif principal ?</p>
      <div className="tags" style={{ flexDirection: "column", gap: 10 }}>
        {goals.map(g => <button key={g} className={`tag ${form.goal === g ? "sel" : ""}`} style={{ textAlign: "left", padding: "14px 18px", borderRadius: 14 }} onClick={() => up("goal", g)}>{g}</button>)}
      </div>
    </div>,

    // 3 - Activity + restrictions
    <div>
      <div className="input-group">
        <label>Niveau d'activité</label>
        <div className="tags" style={{ flexDirection: "column", gap: 8 }}>
          {activities.map((a, i) => <button key={a} className={`tag ${form.activity === a ? "sel" : ""}`} style={{ textAlign: "left", padding: "12px 16px", borderRadius: 12 }} onClick={() => up("activity", a)}>{a}</button>)}
        </div>
      </div>
      <div className="input-group">
        <label>Régimes alimentaires</label>
        <div className="tags">
          {restrictions.map(r => <button key={r} className={`tag ${form.restrictions.includes(r) ? "sel" : ""}`} onClick={() => toggleR(r)}>{r}</button>)}
        </div>
      </div>
    </div>
  ];

  const canNext = [true, form.name && form.weight && form.height, form.goal, true];

  return (
    <div className="app">
      <div className="page">
        {step > 0 && (
          <>
            <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 20 }}>
              <button style={{ background: "none", border: "none", color: "var(--muted)", cursor: "pointer", fontSize: 20 }} onClick={() => setStep(s => s - 1)}>←</button>
              <div className="wizard-steps" style={{ flex: 1 }}>
                {[1, 2, 3].map(i => <div key={i} className={`wizard-step ${step >= i ? "done" : ""}`} />)}
              </div>
            </div>
            <h2 className="page-title" style={{ fontSize: 22, marginBottom: 16 }}>{["", "Votre profil", "Votre objectif", "Activité & régime"][step]}</h2>
          </>
        )}
        {steps[step]}
        {step > 0 && (
          <div style={{ marginTop: 24 }}>
            <button className="btn btn-primary" disabled={!canNext[step]}
              onClick={() => { if (step === 3) { store.set("profile", form); onDone(form); } else setStep(s => s + 1); }}>
              {step === 3 ? "Créer mon profil 🚀" : "Continuer →"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

// ─── Dashboard Page ──────────────────────────────────────────────────────────
function DashboardPage({ profile, meals }) {
  const todayMeals = meals.filter(m => {
    const d = new Date(m.date);
    const n = new Date();
    return d.toDateString() === n.toDateString();
  });

  const totalKcal = todayMeals.reduce((s, m) => s + (m.result?.calories || 0), 0);
  const totalProtein = todayMeals.reduce((s, m) => s + (m.result?.protein || 0), 0);
  const totalCarbs = todayMeals.reduce((s, m) => s + (m.result?.carbs || 0), 0);
  const totalFat = todayMeals.reduce((s, m) => s + (m.result?.fat || 0), 0);

  // Estimate TDEE
  const w = parseFloat(profile.weight) || 70;
  const h = parseFloat(profile.height) || 170;
  const a = parseFloat(profile.age) || 25;
  let bmr = profile.gender === "femme" ? 10 * w + 6.25 * h - 5 * a - 161 : 10 * w + 6.25 * h - 5 * a + 5;
  const actMult = { sédentaire: 1.2, "léger (1-2j/sem)": 1.375, "modéré (3-4j/sem)": 1.55, "actif (5-6j/sem)": 1.725, "très actif": 1.9 };
  const mult = actMult[profile.activity?.toLowerCase()] || 1.55;
  let target = Math.round(bmr * mult);
  if (profile.goal?.includes("Perdre")) target -= 400;
  if (profile.goal?.includes("masse")) target += 300;

  const pct = Math.min(100, Math.round((totalKcal / target) * 100));

  const circumference = 2 * Math.PI * 54;
  const dash = circumference - (circumference * pct) / 100;

  const weekDays = ["L", "M", "M", "J", "V", "S", "D"];
  const today = new Date().getDay();

  return (
    <div className="page">
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 6 }}>
        <div>
          <p className="page-sub" style={{ marginBottom: 0 }}>Bonjour, {profile.name} 👋</p>
          <h1 className="page-title">Aujourd'hui</h1>
        </div>
        <div className="pill">{profile.goal}</div>
      </div>

      {/* Kcal ring */}
      <div className="card" style={{ background: "linear-gradient(135deg, var(--surface) 0%, #1a1a30 100%)" }}>
        <div className="ring-wrap">
          <div className="ring">
            <svg width="120" height="120" viewBox="0 0 120 120">
              <circle cx="60" cy="60" r="54" fill="none" stroke="var(--surface2)" strokeWidth="10" />
              <circle cx="60" cy="60" r="54" fill="none" stroke="var(--accent)" strokeWidth="10"
                strokeDasharray={circumference} strokeDashoffset={dash}
                strokeLinecap="round" style={{ transition: "stroke-dashoffset .6s" }} />
              <text x="60" y="55" textAnchor="middle" fill="var(--text)" fontSize="22" fontWeight="800" fontFamily="Syne">{totalKcal}</text>
              <text x="60" y="72" textAnchor="middle" fill="var(--muted)" fontSize="11" fontFamily="Space Grotesk">kcal</text>
            </svg>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ font: "700 13px var(--font-body)", color: "var(--muted)" }}>Objectif</div>
            <div className="ring-label">{target}</div>
            <div className="ring-sub">kcal / jour</div>
            <div style={{ marginTop: 10 }}>
              <div style={{ display: "flex", justifyContent: "space-between", fontSize: 12, marginBottom: 4 }}>
                <span style={{ color: "var(--muted)" }}>Progression</span>
                <span style={{ color: "var(--accent)", fontWeight: 700 }}>{pct}%</span>
              </div>
              <div className="bar-bg">
                <div className="bar-fill" style={{ width: pct + "%", background: pct > 90 ? "var(--accent3)" : "var(--accent)" }} />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Macros */}
      <div className="macro-row">
        {[
          { name: "Protéines", val: Math.round(totalProtein), unit: "g", color: "var(--accent2)", pct: Math.min(100, (totalProtein / (w * 1.8)) * 100) },
          { name: "Glucides", val: Math.round(totalCarbs), unit: "g", color: "var(--accent)", pct: Math.min(100, (totalCarbs / (target * 0.5 / 4)) * 100) },
          { name: "Lipides", val: Math.round(totalFat), unit: "g", color: "var(--accent3)", pct: Math.min(100, (totalFat / (target * 0.3 / 9)) * 100) },
        ].map(m => (
          <div className="macro-item" key={m.name}>
            <div className="macro-value" style={{ color: m.color }}>{m.val}</div>
            <div className="macro-name">{m.name}</div>
            <div className="bar-bg"><div className="bar-fill" style={{ width: m.pct + "%", background: m.color }} /></div>
          </div>
        ))}
      </div>

      {/* Weekly bars */}
      <div className="card" style={{ marginTop: 14 }}>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 12 }}>7 derniers jours</div>
        <div className="chart-row">
          {weekDays.map((d, i) => {
            const h = 20 + Math.random() * 60;
            const isToday = i === (today === 0 ? 6 : today - 1);
            return (
              <div className="chart-bar-wrap" key={d}>
                <div className={`chart-bar ${isToday ? "today" : ""}`} style={{ height: isToday ? 70 : h }} />
                <span className="chart-day">{d}</span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Recent meals */}
      {todayMeals.length > 0 && (
        <div className="card">
          <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 12 }}>Repas d'aujourd'hui</div>
          {todayMeals.slice(-3).reverse().map((m, i) => (
            <div className="meal-entry" key={i}>
              <div className="meal-thumb">{m.preview ? <img src={m.preview} style={{ width: "100%", height: "100%", borderRadius: 12, objectFit: "cover" }} /> : "🍽️"}</div>
              <div className="meal-info">
                <h4>{m.result?.name || "Aliment"}</h4>
                <p>{m.result?.protein || 0}g prot · {m.result?.carbs || 0}g gl · {m.result?.fat || 0}g lip</p>
              </div>
              <div className="meal-kcal">{m.result?.calories || 0}</div>
            </div>
          ))}
        </div>
      )}

      {todayMeals.length === 0 && (
        <div className="card" style={{ textAlign: "center", padding: 32 }}>
          <div style={{ fontSize: 40 }}>📸</div>
          <p style={{ marginTop: 10, color: "var(--muted)", fontSize: 14 }}>Aucun repas enregistré aujourd'hui.<br />Prenez une photo de votre prochain repas !</p>
        </div>
      )}
      <div style={{ height: 20 }} />
    </div>
  );
}

// ─── Food Scanner Page ───────────────────────────────────────────────────────
function ScanPage({ onMealAdded }) {
  const [image, setImage] = useState(null);
  const [preview, setPreview] = useState(null);
  const [analyzing, setAnalyzing] = useState(false);
  const [result, setResult] = useState(null);
  const [toast, setToast] = useState(null);
  const fileRef = useRef();

  const showToast = msg => { setToast(msg); setTimeout(() => setToast(null), 2500); };

  const handleFile = async (file) => {
    if (!file) return;
    const url = URL.createObjectURL(file);
    setPreview(url);
    setResult(null);

    const reader = new FileReader();
    reader.onload = async e => {
      const b64 = e.target.result.split(",")[1];
      setImage(b64);
      setAnalyzing(true);
      const r = await analyzeFood(b64);
      setAnalyzing(false);
      if (r) setResult(r);
      else showToast("Erreur d'analyse — réessayez");
    };
    reader.readAsDataURL(file);
  };

  const save = () => {
    if (!result) return;
    onMealAdded({ date: new Date().toISOString(), preview, result });
    showToast("✅ Repas enregistré !");
    setPreview(null); setResult(null); setImage(null);
  };

  const scoreColor = s => s >= 7 ? "var(--accent)" : s >= 4 ? "#ffcc00" : "var(--accent3)";

  return (
    <div className="page">
      {toast && <div className="toast">{toast}</div>}
      <h1 className="page-title">Analyser un repas</h1>
      <p className="page-sub">Prenez une photo de votre nourriture pour analyser les nutriments</p>

      <div className="photo-drop" onClick={() => fileRef.current.click()}>
        <input type="file" ref={fileRef} accept="image/*" capture="environment" onChange={e => handleFile(e.target.files[0])} />
        {preview ? (
          <img src={preview} alt="repas" />
        ) : (
          <>
            <div className="photo-icon">📸</div>
            <div style={{ fontWeight: 600, marginBottom: 4 }}>Ajouter une photo</div>
            <div className="photo-hint">Touchez pour prendre une photo ou choisir dans la galerie</div>
          </>
        )}
      </div>

      {analyzing && (
        <div className="card">
          <div className="analyzing">
            <div className="spinner" />
            <div style={{ fontWeight: 600 }}>Analyse en cours…</div>
            <div className="pulse-text" style={{ color: "var(--muted)", fontSize: 13 }}>Identification des nutriments par IA</div>
          </div>
        </div>
      )}

      {result && (
        <>
          <div className="card" style={{ border: "1px solid var(--accent)40" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
              <div>
                <h3 style={{ fontFamily: "var(--font-head)", fontSize: 20, fontWeight: 800 }}>{result.name}</h3>
                <div style={{ marginTop: 6, display: "flex", alignItems: "center", gap: 10 }}>
                  <span style={{ fontFamily: "var(--font-head)", fontSize: 32, fontWeight: 800, color: "var(--accent)" }}>{result.calories}</span>
                  <span style={{ color: "var(--muted)", fontSize: 14 }}>kcal</span>
                </div>
              </div>
              <div style={{ textAlign: "center" }}>
                <div style={{ fontSize: 28, fontWeight: 800, fontFamily: "var(--font-head)", color: scoreColor(result.healthScore) }}>{result.healthScore}/10</div>
                <div style={{ fontSize: 11, color: "var(--muted)" }}>Score santé</div>
              </div>
            </div>

            <div className="nutrient-grid">
              {[
                { label: "Protéines", val: result.protein, unit: "g", color: "var(--accent2)" },
                { label: "Glucides", val: result.carbs, unit: "g", color: "var(--accent)" },
                { label: "Lipides", val: result.fat, unit: "g", color: "var(--accent3)" },
                { label: "Fibres", val: result.fiber, unit: "g", color: "#a0ff5a" },
              ].map(n => (
                <div className="nutrient-tile" key={n.label}>
                  <div className="nutrient-val" style={{ color: n.color }}>{n.val}<span className="nutrient-unit"> {n.unit}</span></div>
                  <div style={{ fontSize: 12, color: "var(--muted)", marginTop: 2 }}>{n.label}</div>
                </div>
              ))}
            </div>

            {(result.vitamins || result.minerals) && (
              <div style={{ marginTop: 14, background: "var(--surface2)", borderRadius: 12, padding: "10px 14px" }}>
                <div style={{ fontSize: 12, color: "var(--muted)", marginBottom: 4 }}>🧪 Micronutriments</div>
                <div style={{ fontSize: 13 }}>{result.vitamins} · {result.minerals}</div>
              </div>
            )}

            {result.tip && (
              <div style={{ marginTop: 12, background: "var(--accent)12", border: "1px solid var(--accent)30", borderRadius: 12, padding: "10px 14px" }}>
                <div style={{ fontSize: 12, color: "var(--accent)", marginBottom: 2, fontWeight: 600 }}>💡 Conseil</div>
                <div style={{ fontSize: 13 }}>{result.tip}</div>
              </div>
            )}
          </div>

          <button className="btn btn-primary" onClick={save}>Enregistrer ce repas ✓</button>
          <button className="btn btn-secondary" style={{ marginTop: 10 }} onClick={() => { setPreview(null); setResult(null); }}>Nouvelle photo</button>
        </>
      )}
      <div style={{ height: 20 }} />
    </div>
  );
}

// ─── Progress Page ───────────────────────────────────────────────────────────
function ProgressPage({ meals, profile }) {
  const [newWeight, setNewWeight] = useState("");
  const [weights, setWeights] = useState(() => store.get("weights") || [{ date: new Date().toISOString(), val: parseFloat(profile.weight) || 70 }]);
  const [toast, setToast] = useState(null);
  const showToast = msg => { setToast(msg); setTimeout(() => setToast(null), 2000); };

  const logWeight = () => {
    if (!newWeight) return;
    const updated = [...weights, { date: new Date().toISOString(), val: parseFloat(newWeight) }];
    setWeights(updated);
    store.set("weights", updated);
    setNewWeight("");
    showToast("✅ Poids enregistré");
  };

  const recent = weights.slice(-7);
  const minW = Math.min(...recent.map(w => w.val)) - 1;
  const maxW = Math.max(...recent.map(w => w.val)) + 1;
  const range = maxW - minW || 1;

  const last7Meals = meals.slice(-7);
  const avgKcal = last7Meals.length ? Math.round(last7Meals.reduce((s, m) => s + (m.result?.calories || 0), 0) / last7Meals.length) : 0;

  return (
    <div className="page">
      {toast && <div className="toast">{toast}</div>}
      <h1 className="page-title">Progression</h1>
      <p className="page-sub">{meals.length} repas analysés au total</p>

      {/* Weight chart */}
      <div className="card">
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 16 }}>📊 Évolution du poids</div>
        <div style={{ height: 100, position: "relative", display: "flex", alignItems: "flex-end", gap: 8 }}>
          {recent.map((w, i) => {
            const h = ((w.val - minW) / range) * 80 + 10;
            return (
              <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
                <div style={{ fontSize: 9, color: "var(--muted)" }}>{w.val}kg</div>
                <div style={{ width: "100%", height: h, background: i === recent.length - 1 ? "var(--accent)" : "var(--accent)40", borderRadius: "6px 6px 0 0" }} />
                <div style={{ fontSize: 9, color: "var(--muted)" }}>{new Date(w.date).toLocaleDateString("fr", { day: "numeric", month: "numeric" })}</div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Log weight */}
      <div className="card">
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 12 }}>Enregistrer mon poids</div>
        <div style={{ display: "flex", gap: 10 }}>
          <input type="number" step="0.1" placeholder="Ex: 72.5" value={newWeight} onChange={e => setNewWeight(e.target.value)} style={{ flex: 1 }} />
          <button className="btn btn-primary btn-sm" onClick={logWeight}>Ajouter</button>
        </div>
      </div>

      {/* Stats */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        {[
          { label: "Repas logués", val: meals.length, unit: "total", color: "var(--accent2)" },
          { label: "Moy. kcal/repas", val: avgKcal, unit: "kcal", color: "var(--accent)" },
          { label: "Poids initial", val: profile.weight || "—", unit: "kg", color: "var(--muted)" },
          { label: "Poids actuel", val: weights[weights.length - 1]?.val || "—", unit: "kg", color: "var(--accent3)" },
        ].map(s => (
          <div className="card" key={s.label} style={{ marginBottom: 0 }}>
            <div style={{ fontSize: 26, fontWeight: 800, fontFamily: "var(--font-head)", color: s.color }}>{s.val}<span style={{ fontSize: 12, color: "var(--muted)", fontFamily: "var(--font-body)" }}> {s.unit}</span></div>
            <div style={{ fontSize: 12, color: "var(--muted)", marginTop: 2 }}>{s.label}</div>
          </div>
        ))}
      </div>

      {/* Meal history */}
      <div className="card" style={{ marginTop: 14 }}>
        <div style={{ fontSize: 13, fontWeight: 600, marginBottom: 12 }}>Historique des repas</div>
        {meals.length === 0 && <p style={{ color: "var(--muted)", fontSize: 13 }}>Aucun repas enregistré</p>}
        {meals.slice().reverse().slice(0, 10).map((m, i) => (
          <div className="meal-entry" key={i}>
            <div className="meal-thumb">{m.preview ? <img src={m.preview} style={{ width: "100%", height: "100%", borderRadius: 12, objectFit: "cover" }} /> : "🍽️"}</div>
            <div className="meal-info">
              <h4>{m.result?.name || "Aliment"}</h4>
              <p>{new Date(m.date).toLocaleDateString("fr", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}</p>
            </div>
            <div className="meal-kcal">{m.result?.calories || 0}<span style={{ fontSize: 10, color: "var(--muted)" }}> kcal</span></div>
          </div>
        ))}
      </div>
      <div style={{ height: 20 }} />
    </div>
  );
}

// ─── AI Coach Page ───────────────────────────────────────────────────────────
function CoachPage({ profile, meals }) {
  const [messages, setMessages] = useState([
    { role: "assistant", content: `Bonjour ${profile.name} ! 👋 Je suis votre coach FitAI. Je connais votre profil et vos repas. Posez-moi des questions sur votre nutrition, un planning repas, ou vos objectifs !` }
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef();

  useEffect(() => { bottomRef.current?.scrollIntoView({ behavior: "smooth" }); }, [messages]);

  const send = async () => {
    if (!input.trim() || loading) return;
    const userMsg = { role: "user", content: input };
    const newMsgs = [...messages, userMsg];
    setMessages(newMsgs);
    setInput("");
    setLoading(true);

    const profileWithMeals = { ...profile, recentMeals: meals.slice(-5).map(m => m.result?.name) };
    const reply = await askNutritionAI(newMsgs.map(m => ({ role: m.role, content: m.content })), profileWithMeals);
    setMessages(m => [...m, { role: "assistant", content: reply }]);
    setLoading(false);
  };

  const suggestions = ["Propose un plan repas pour demain", "Quels aliments pour prendre de la masse ?", "Mon bilan nutritionnel de la semaine", "Meilleurs snacks post-workout"];

  return (
    <div className="page" style={{ display: "flex", flexDirection: "column", paddingBottom: 0 }}>
      <h1 className="page-title">Coach IA</h1>
      <p className="page-sub">Votre assistant nutrition personnalisé</p>

      {messages.length === 1 && (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, marginBottom: 16 }}>
          {suggestions.map(s => (
            <button key={s} className="card" style={{ textAlign: "left", cursor: "pointer", border: "1px solid var(--border)", fontSize: 13, padding: "12px 16px", borderRadius: 14, color: "var(--text)", background: "var(--surface)", width: "100%" }}
              onClick={() => { setInput(s); }}>
              💬 {s}
            </button>
          ))}
        </div>
      )}

      <div style={{ flex: 1, overflowY: "auto", paddingBottom: 80 }}>
        {messages.map((m, i) => (
          <div key={i} style={{ display: "flex", flexDirection: m.role === "user" ? "row-reverse" : "row" }}>
            <div className={`chat-bubble ${m.role}`}>{m.content}</div>
          </div>
        ))}
        {loading && (
          <div style={{ display: "flex" }}>
            <div className="chat-bubble ai" style={{ display: "flex", gap: 6, alignItems: "center" }}>
              <div className="spinner" style={{ width: 16, height: 16, borderWidth: 2 }} />
              <span style={{ color: "var(--muted)", fontSize: 13 }}>En train de répondre…</span>
            </div>
          </div>
        )}
        <div ref={bottomRef} />
      </div>

      <div className="chat-input-row">
        <input placeholder="Posez une question…" value={input} onChange={e => setInput(e.target.value)} onKeyDown={e => e.key === "Enter" && send()} />
        <button className="send-btn" onClick={send}>↑</button>
      </div>
    </div>
  );
}

// ─── Profile Page ────────────────────────────────────────────────────────────
function ProfilePage({ profile, onUpdate }) {
  const [form, setForm] = useState(profile);
  const [saved, setSaved] = useState(false);

  const up = (k, v) => setForm(f => ({ ...f, [k]: v }));
  const save = () => { store.set("profile", form); onUpdate(form); setSaved(true); setTimeout(() => setSaved(false), 2000); };

  // BMI
  const bmi = form.weight && form.height ? (parseFloat(form.weight) / Math.pow(parseFloat(form.height) / 100, 2)).toFixed(1) : "—";
  const bmiLabel = bmi === "—" ? "" : bmi < 18.5 ? "Insuffisant" : bmi < 25 ? "Normal ✓" : bmi < 30 ? "Surpoids" : "Obésité";

  return (
    <div className="page">
      {saved && <div className="toast">✅ Profil mis à jour</div>}
      <h1 className="page-title">Mon profil</h1>

      {/* BMI card */}
      <div className="card" style={{ background: "linear-gradient(135deg, var(--surface) 0%, #1a1a30 100%)", marginBottom: 20 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div>
            <div style={{ fontSize: 12, color: "var(--muted)", fontWeight: 600, textTransform: "uppercase" }}>IMC</div>
            <div style={{ fontFamily: "var(--font-head)", fontSize: 48, fontWeight: 800, color: "var(--accent)", lineHeight: 1 }}>{bmi}</div>
            <div style={{ fontSize: 13, color: "var(--muted)", marginTop: 4 }}>{bmiLabel}</div>
          </div>
          <div style={{ textAlign: "right" }}>
            <div style={{ fontSize: 13, color: "var(--muted)" }}>Objectif</div>
            <div style={{ fontSize: 16, fontWeight: 700, marginTop: 2 }}>{form.goal || "—"}</div>
            <div style={{ fontSize: 12, color: "var(--muted)", marginTop: 6 }}>{form.activity}</div>
          </div>
        </div>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
        <div className="input-group"><label>Prénom</label><input value={form.name} onChange={e => up("name", e.target.value)} /></div>
        <div className="input-group"><label>Âge</label><input type="number" value={form.age} onChange={e => up("age", e.target.value)} /></div>
        <div className="input-group"><label>Poids (kg)</label><input type="number" step="0.1" value={form.weight} onChange={e => up("weight", e.target.value)} /></div>
        <div className="input-group"><label>Taille (cm)</label><input type="number" value={form.height} onChange={e => up("height", e.target.value)} /></div>
      </div>

      <div className="input-group">
        <label>Objectif</label>
        <select value={form.goal} onChange={e => up("goal", e.target.value)}>
          {["Perdre du poids", "Prendre de la masse", "Maintenir", "Améliorer l'endurance", "Manger sainement"].map(g => <option key={g}>{g}</option>)}
        </select>
      </div>

      <div className="input-group">
        <label>Niveau d'activité</label>
        <select value={form.activity} onChange={e => up("activity", e.target.value)}>
          {["Sédentaire", "Léger (1-2j/sem)", "Modéré (3-4j/sem)", "Actif (5-6j/sem)", "Très actif"].map(a => <option key={a}>{a}</option>)}
        </select>
      </div>

      <button className="btn btn-primary" onClick={save}>Sauvegarder le profil</button>

      <div style={{ marginTop: 24, marginBottom: 10, fontSize: 13, fontWeight: 600, color: "var(--muted)" }}>INFORMATIONS APP</div>
      {[
        { label: "Version", val: "1.0.0" },
        { label: "Mode", val: "Online (IA active)" },
        { label: "Modèle IA", val: "Claude Sonnet 4" },
      ].map(r => (
        <div key={r.label} style={{ display: "flex", justifyContent: "space-between", padding: "12px 0", borderBottom: "1px solid var(--border)", fontSize: 14 }}>
          <span style={{ color: "var(--muted)" }}>{r.label}</span>
          <span style={{ fontWeight: 600 }}>{r.val}</span>
        </div>
      ))}
      <div style={{ height: 30 }} />
    </div>
  );
}

// ─── Root App ────────────────────────────────────────────────────────────────
export default function App() {
  const [profile, setProfile] = useState(() => store.get("profile"));
  const [tab, setTab] = useState("home");
  const [meals, setMeals] = useState(() => store.get("meals") || []);

  const addMeal = useCallback(meal => {
    setMeals(prev => {
      const updated = [...prev, meal];
      store.set("meals", updated);
      return updated;
    });
    setTab("home");
  }, []);

  if (!profile) return (
    <>
      <style>{css}</style>
      <Onboarding onDone={p => { store.set("profile", p); setProfile(p); }} />
    </>
  );

  const tabs = [
    { id: "home", label: "Accueil", Icon: Icons.Home },
    { id: "scan", label: "Scanner", Icon: Icons.Camera },
    { id: "coach", label: "Coach", Icon: Icons.Chat },
    { id: "progress", label: "Stats", Icon: Icons.Chart },
    { id: "profile", label: "Profil", Icon: Icons.User },
  ];

  return (
    <>
      <style>{css}</style>
      <div className="app">
        {tab === "home" && <DashboardPage profile={profile} meals={meals} />}
        {tab === "scan" && <ScanPage onMealAdded={addMeal} />}
        {tab === "coach" && <CoachPage profile={profile} meals={meals} />}
        {tab === "progress" && <ProgressPage meals={meals} profile={profile} />}
        {tab === "profile" && <ProfilePage profile={profile} onUpdate={p => { setProfile(p); }} />}

        <nav className="nav">
          {tabs.map(({ id, label, Icon }) => (
            <button key={id} className={`nav-btn ${tab === id ? "active" : ""}`} onClick={() => setTab(id)}>
              <Icon />{label}
            </button>
          ))}
        </nav>
      </div>
    </>
  );
}
