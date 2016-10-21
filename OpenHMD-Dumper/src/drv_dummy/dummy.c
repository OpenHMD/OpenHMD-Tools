/*
 * OpenHMD - Free and Open Source API and drivers for immersive technology.
 * Copyright (C) 2013 Fredrik Hultin.
 * Copyright (C) 2013 Jakob Bornecrantz.
 * Distributed under the Boost 1.0 licence, see LICENSE for full text.
 */

/* Dummy Driver */

#include <string.h>
#include "../openhmdi.h"

typedef struct {
	ohmd_device base;
} dummy_priv;

static void update_device(ohmd_device* device)
{
}

static int getf(ohmd_device* device, ohmd_float_value type, float* out)
{
	dummy_priv* priv = (dummy_priv*)device;

	switch(type){
	case OHMD_ROTATION_QUAT: 
		out[0] = out[1] = out[2] = 0;
		out[3] = 1.0f;
		break;

	case OHMD_POSITION_VECTOR:
		out[0] = out[1] = out[2] = 0;
		break;

	case OHMD_DISTORTION_K:
		// TODO this should be set to the equivalent of no distortion
		memset(out, 0, sizeof(float) * 6);
		break;

	default:
		ohmd_set_error(priv->base.ctx, "invalid type given to getf (%ud)", type);
		return -1;
		break;
	}

	return 0;
}

static void close_device(ohmd_device* device)
{
	LOGD("closing dummy device");
	free(device);
}

static ohmd_device* open_device(ohmd_driver* driver, ohmd_device_desc* desc)
{
	dummy_priv* priv = ohmd_alloc(driver->ctx, sizeof(dummy_priv));
	if(!priv)
		return NULL;
	
	// Set default device properties
	ohmd_set_default_device_properties(&priv->base.properties);

	// Set device properties (imitates the rift values)
	priv->base.properties.hsize = 0.149760f;
	priv->base.properties.vsize = 0.093600f;
	priv->base.properties.hres = 1280;
	priv->base.properties.vres = 800;
	priv->base.properties.lens_sep = 0.063500;
	priv->base.properties.lens_vpos = 0.046800;
	priv->base.properties.fov = DEG_TO_RAD(125.5144f);
	priv->base.properties.ratio = (1280.0f / 800.0f) / 2.0f;

	// calculate projection eye projection matrices from the device properties
	ohmd_calc_default_proj_matrices(&priv->base.properties);

	// set up device callbacks
	priv->base.update = update_device;
	priv->base.close = close_device;
	priv->base.getf = getf;
	
	return (ohmd_device*)priv;
}

static void get_device_list(ohmd_driver* driver, ohmd_device_list* list)
{
	ohmd_device_desc* desc = &list->devices[list->num_devices++];

	strcpy(desc->driver, "OpenHMD Dummy Driver");
	strcpy(desc->vendor, "OpenHMD");
	strcpy(desc->product, "Dummy Device");

	strcpy(desc->path, "(none)");

	desc->driver_ptr = driver;
}

static void destroy_driver(ohmd_driver* drv)
{
	LOGD("shutting down dummy driver");
	free(drv);
}

ohmd_driver* ohmd_create_dummy_drv(ohmd_context* ctx)
{
	ohmd_driver* drv = ohmd_alloc(ctx, sizeof(ohmd_driver));
	if(!drv)
		return NULL;

	drv->get_device_list = get_device_list;
	drv->open_device = open_device;
	drv->get_device_list = get_device_list;
	drv->open_device = open_device;
	drv->destroy = destroy_driver;

	return drv;
}
