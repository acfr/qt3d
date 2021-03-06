/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0
import Qt3D 1.0
import Qt3D.Shapes 1.0

Rectangle {
    id: container
    // Parameters for editting
    property string text;
    property variant testTransform: defaultTransform
    property real scaleFactor: 1.0
    property variant scaleVectorA: Qt.vector3d(1,1,1)
    property variant scaleVectorB: Qt.vector3d(1,1,1)
    property variant camera: defaultCamera

    // Default values:
    property variant defaultCamera: Camera { eye: Qt.vector3d(0,5,5)}
    property real defaultWidth: 220
    property real defaultHeight: 150
    property variant defaultTransform: Scale3D {
        scale: Qt.vector3d((scaleVectorA.x * animationFactor +
                            scaleVectorB.x * (1.0 - animationFactor)),
                           scaleVectorA.y * animationFactor +
                           scaleVectorB.y * (1.0 - animationFactor),
                           scaleVectorA.z * animationFactor +
                           scaleVectorB.z * (1.0 - animationFactor))
        property real animationFactor: 1.0

        SequentialAnimation on animationFactor {
            loops: Animation.Infinite
            PropertyAnimation {
                from: 1.0
                to: 0.0
                duration: 2000
            }
            PropertyAnimation {
                from: 0.0
                to: 1.0
                duration: 2000
            }
        }
    }

    border.width: 2
    border.color: "black"
    radius: 5
    width: defaultWidth
    height: defaultHeight

    Text {
        id: textItem
        wrapMode: "WordWrap"
        horizontalAlignment: "AlignHCenter"
        text: container.text
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Rectangle {
        id: viewportContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        anchors.topMargin: 2
        anchors.top: textItem.bottom
        anchors.bottom: container.bottom
        color: "#aaccee"

        Viewport {
            id: view
            anchors.fill: parent
            picking: true
            camera: container.camera
            Teapot
            {
                id: model
                scale: container.scaleFactor
                transform: container.testTransform
            }
        }
    }
}
