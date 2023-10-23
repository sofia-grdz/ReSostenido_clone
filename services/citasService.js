class CitasService {
  constructor(database) {
    this.database = database;
  }

  async getCitaNoPagadaAndCorrespondingServiceById(id) {
    const [citas, campos] = await this.database.execute(
      'SELECT citas.id, citas.precio_anticipo_total, citas.incluye_cuerdas, citas.pagada, citas.fecha, citas.hora, servicios.descripcion AS descripcion_servicio, servicios.nombre_instrumento FROM citas INNER JOIN servicios ON citas.id_servicio = servicios.id AND citas.id = ? AND pagada = false AND servicios.activo = true',
      [id]
    );

    return citas[0];
  }

  async verificarDisponibilidadCita(fecha, hora, fechaYHoraActual = null) {
    try {
      const result = await this.database.execute(
        'SELECT validar_disponibilidad_fecha_cita(?, ?, ?)',
        [fecha, hora, fechaYHoraActual]
      );
      const { disponibilidad, mensaje } = Object.values(result[0][0])[0];
      return { disponibilidad, mensaje };
    } catch (err) {
      console.error(err);
    }
  }

  async crearCitaNoPagada({
    fecha,
    hora,
    descripcion,
    incluye_cuerdas,
    precio_anticipo_total,
    id_servicio,
    id_usuario,
  }) {
    const [resultadoInsert] = await this.database.execute(
      'INSERT INTO citas (fecha, hora, descripcion, incluye_cuerdas, precio_anticipo_total, id_servicio, id_usuario) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        fecha,
        hora,
        descripcion,
        incluye_cuerdas,
        precio_anticipo_total,
        id_servicio,
        id_usuario,
      ]
    );
    const idCita = resultadoInsert.insertId;

    return idCita;
  }

  async actualizarCitaAEstadoPagada(idCita) {
    await this.database.execute('UPDATE citas SET pagada = true WHERE id = ?', [
      idCita,
    ]);
  }
}

module.exports = CitasService;
