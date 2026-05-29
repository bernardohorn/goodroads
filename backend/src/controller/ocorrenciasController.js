const pool = require('../config/banco');

async function listarOcorrencias(req, res) {
  try {
    const { rows } = await pool.query(
      `SELECT * FROM vw_ocorrencias_abertas LIMIT 50`
    );
    return res.json(rows);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ erro: 'Erro interno' });
  }
}

module.exports = { listarOcorrencias };