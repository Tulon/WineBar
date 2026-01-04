/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025 Josif Arcimovic
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "PrintHexEncodedByteArray.h"
#include "PrintQuotedAndEscapedJsonString.h"

#include <vulkan/vulkan.h>

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static char const*
deviceTypeToString(VkPhysicalDeviceType type)
{
    switch (type)
    {
    case VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU:
        return "integrated";
    case VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
        return "discrete";
    case VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU:
        return "virtual";
    case VK_PHYSICAL_DEVICE_TYPE_CPU:
        return "software";
    case VK_PHYSICAL_DEVICE_TYPE_OTHER:
    default:
        return "other";
    }
}

int
main(int argc, char** argv)
{
    VkApplicationInfo appInfo = {
        .sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .applicationVersion = VK_MAKE_VERSION(0, 0, 0),
        .engineVersion = VK_MAKE_VERSION(0, 0, 0),
        .apiVersion = VK_API_VERSION_1_1};

    VkInstanceCreateInfo createInfo = {
        .sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pApplicationInfo = &appInfo,
    };

    VkResult res;
    VkInstance instance;

    res = vkCreateInstance(&createInfo, NULL, &instance);
    if (res != VK_SUCCESS)
    {
        fprintf(stderr, "vkCreateInstance() failed with code %d\n", (int)res);
        return EXIT_FAILURE;
    }

    uint32_t numDevices = 0;
    res = vkEnumeratePhysicalDevices(instance, &numDevices, NULL);
    if (res != VK_SUCCESS)
    {
        fprintf(stderr, "vkEnumeratePhysicalDevices() failed with code %d\n", (int)res);
        vkDestroyInstance(instance, NULL);
        return EXIT_FAILURE;
    }

    VkPhysicalDevice devices[numDevices];
    res = vkEnumeratePhysicalDevices(instance, &numDevices, devices);
    if (res != VK_SUCCESS)
    {
        fprintf(stderr, "vkEnumeratePhysicalDevices() failed with code %d\n", (int)res);
        vkDestroyInstance(instance, NULL);
        return EXIT_FAILURE;
    }

    printf("{\n  \"gpus\": [\n");

    bool hasPrevDeviceInOutput = false;

    for (uint32_t i = 0; i < numDevices; ++i)
    {
        VkPhysicalDeviceVulkan11Properties v11Props = {
            .sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_1_PROPERTIES,
        };

        VkPhysicalDeviceProperties2 props2 = {
            .sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2,
            .pNext = &v11Props,
        };

        vkGetPhysicalDeviceProperties2(devices[i], &props2);

        if (props2.properties.deviceType == VK_PHYSICAL_DEVICE_TYPE_CPU)
        {
            // Skip software-emulated GPUs.
            continue;
        }

        if (hasPrevDeviceInOutput)
        {
            printf(",\n");
        }

        printf("    {\n");

        printf("      \"name\": ");
        printQuotedAndEscapedJsonString(stdout, props2.properties.deviceName);
        printf(",\n");

        printf("      \"deviceType\": \"%s\",\n", deviceTypeToString(props2.properties.deviceType));

        printf("      \"deviceUuid\": \"");
        printHexEncodedByteArray(stdout, v11Props.deviceUUID, sizeof(v11Props.deviceUUID));
        printf("\",\n");

        printf("      \"deviceId\": \"%04x\",\n", (unsigned)props2.properties.deviceID);

        printf("      \"vendorId\": \"%04x\"\n", (unsigned)props2.properties.vendorID);

        printf("    }");

        hasPrevDeviceInOutput = true;
    }

    printf("\n  ]\n}\n");

    vkDestroyInstance(instance, NULL);

    return EXIT_SUCCESS;
}
